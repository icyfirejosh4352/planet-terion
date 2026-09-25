extends CharacterBody2D

@export var min_shard_value : int = 5
@export var max_shard_value : int = 10
@export var gravity : float = 1000.0
@onready var pickup_area: Area2D = $PickupArea
var collected = false

func _ready() -> void:
	pickup_area.body_entered.connect(_on_player_entered)

func launch(offset: Vector2) -> void:
	velocity = Vector2(offset.x * 3.0, offset.y * 4.0)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	velocity.x = move_toward(velocity.x, 0.0, 450 * delta)
	move_and_slide()

func _on_player_entered(body: Node2D) -> void:
	if collected or not body.is_in_group("Player"):
		return
	collected = true	
	var shard_value: int = randi_range(min_shard_value, max_shard_value)
	ShardBank.add_shard(shard_value)
	queue_free()
