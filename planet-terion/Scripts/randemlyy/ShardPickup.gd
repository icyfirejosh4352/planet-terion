extends CharacterBody2D

@export var min_shard_value : int = 5
@export var max_shard_value : int = 10
@export var gravity : float = 1000.0
@export var bob_height: float = 0.8
@export var bob_speed: float = 0.5
@export var attraction_radius: float = 48.0
@export var attraction_accel: float = 500.0
@export var max_attraction_speed: float = 240.0
@onready var pickup_area: Area2D = $PickupArea
@onready var sprite: Sprite2D = $Sprite2D
var collected = false
var landed = false
var bob_time = 0.0

func _ready() -> void:
	pickup_area.body_entered.connect(_on_player_entered)

func launch(offset: Vector2) -> void:
	velocity = Vector2(offset.x * 3.0, offset.y * 4.0)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta / 0.7
	velocity.x = move_toward(velocity.x, 0.0, 450 * delta)
	move_and_slide()
	if is_on_floor():
		landed = true

	if landed:
		var player = get_tree().get_first_node_in_group("Player")
		if player:
			var to_player = player.global_position - global_position
			var distance = to_player.length()
			
			if distance <= attraction_radius:
				var target_position = player.global_position
				
				if distance < 20.0:
					target_position += Vector2(0, -12)
				to_player = target_position - global_position
				var closeness = 1.0 - distance / attraction_radius
				var target_speed = lerp(40.0, max_attraction_speed, closeness)
				velocity = velocity.move_toward(
					to_player * target_speed,
					attraction_accel * delta
				)
				move_and_slide()
				
				if distance < 8.0:
					_on_player_entered(player)
				return
				
		bob_time += delta
		var bob_offset = sin(bob_time * TAU * bob_speed) * bob_height
		sprite.position.y = bob_offset
		pickup_area.position.y = bob_offset

func _on_player_entered(body: Node2D) -> void:
	if collected or not body.is_in_group("Player"):
		return
	collected = true	
	var shard_value: int = randi_range(min_shard_value, max_shard_value)
	ShardBank.add_shard(shard_value)
	queue_free()
