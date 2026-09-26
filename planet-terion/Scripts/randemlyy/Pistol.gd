class_name Pistol
extends Weapon

@export var bullet_range: float = 512.0
@export var bullet_speed: float = 740.0
@export var bullet_width: float = 8.0


func attack(direction: Vector2) -> void:
	if not can_attack():
		return
	
	var dir = direction.normalized()
	if dir.length() == 0:
		return
	
	ScreenShakeManager.shake(0.2, 1.6, Vector2(10, 10))
	
	var bullet = load("res://Scenes/randemlyy/Bullet.tscn").instantiate()
	print("Bullet instantiated:", bullet, "at position:", global_position)
	
	bullet.global_position = global_position
	bullet.rotation = dir.angle()
	
	bullet.global_position += dir * 12
	get_tree().current_scene.add_child(bullet)
	cooldown_timer = pistol_firerate
	
	
