class_name Weapon
extends Node2D

@export var damage: float = 10.0
@export var pistol_firerate: float = 1.2
@export var knife_firerate: float = 0.5
var cooldown_timer: float = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if cooldown_timer > 0:
		cooldown_timer -= delta

func can_attack() -> bool:
	return cooldown_timer <= 0

func attack(direction: Vector2) -> void:
	pass

func upgrade_damage(amount: float) -> void:
	damage += amount

#func upgrade_firerate(amount: float) -> void:
	#firerate = max(0.1, firerate - amount)
