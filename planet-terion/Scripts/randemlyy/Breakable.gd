extends Node2D

@export var health := 15.0
@export var accepted_attacks: Array[StringName] = [&"bullet"]
@onready var sprite: Sprite2D = $Sprite2D
@export var wobble_degrees: float = 3.0
var base_rotation: float
var wobble_tween: Tween

func take_hit(amount: float, attack_type: StringName) -> void:
	if not accepted_attacks.has(attack_type):
		return
	health -= amount
	play_wobble()
	if health <= 0.0:
		queue_free()


func play_wobble() -> void:
	if wobble_tween and wobble_tween.is_running():
		wobble_tween.kill()
	
	sprite.rotation = base_rotation
	var wobble = deg_to_rad(wobble_degrees)
	
	wobble_tween = create_tween()
	wobble_tween.tween_property(sprite, "rotation", base_rotation + wobble, 0.04)
	wobble_tween.tween_property(sprite, "rotation", base_rotation - wobble, 0.07)
	wobble_tween.tween_property(sprite, "rotation", base_rotation, 0.05)
