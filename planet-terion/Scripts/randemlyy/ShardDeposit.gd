extends StaticBody2D

const SHARD_PICKUP = preload("res://Scenes/randemlyy/ShardPickup.tscn")


@export var min_shards: int = 5
@export var max_shards: int = 8
@export var wobble_degrees: float = 8.0
@onready var health_component: HealthComponent = $HealthComponent
@onready var deposit_sprite: Sprite2D = $Sprite2D

var broken: = false
var base_rotation: float
var wobble_tween: Tween

func _ready() -> void:
	base_rotation = deposit_sprite.rotation
	health_component.damaged.connect(_on_damaged)

func _on_damaged(_amount: float) -> void:
	if broken:
		return
	play_wobble()
	
	if health_component.health <= 0:
		break_deposit()
	
func play_wobble() -> void:
	if wobble_tween and wobble_tween.is_running():
		wobble_tween.kill()
	
	deposit_sprite.rotation = base_rotation
	var wobble = deg_to_rad(wobble_degrees)
	
	wobble_tween = create_tween()
	wobble_tween.tween_property(deposit_sprite, "rotation", base_rotation + wobble, 0.04)
	wobble_tween.tween_property(deposit_sprite, "rotation", base_rotation - wobble, 0.07)
	wobble_tween.tween_property(deposit_sprite, "rotation", base_rotation, 0.05)

func break_deposit() -> void:
	broken = true
	
	var drop_count = randi_range(min_shards, max_shards)
	var scene = get_tree().current_scene
	
	for i in range(drop_count):
		var pickup = SHARD_PICKUP.instantiate()
		scene.add_child(pickup)
		pickup.global_position = global_position
		
		var offset := Vector2(
			randf_range(-35, 35),
			randf_range(-45, -25)
		)
		
		pickup.launch(offset)
		
		queue_free()
