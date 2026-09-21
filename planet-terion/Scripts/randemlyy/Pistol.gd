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
	
	var bullet = load("res://Scenes/randemlyy/Bullet.tscn").instantiate()
	print("Bullet instantiated:", bullet, "at position:", global_position)
	
	bullet.global_position = global_position
	bullet.rotation = dir.angle()
	
	bullet.global_position += dir * 12
	get_tree().current_scene.add_child(bullet)
	
	
	#var start = global_position
	#var end = start + dir * bullet_range
	#
	#var space = get_world_2d().direct_space_state
	#var params = PhysicsRayQueryParameters2D.create(start, end)
	#params.collide_with_areas = true
	#params.collide_with_bodies = true
	#
	#var result = space.intersect_ray(params)
	#if result:
		#var body = result.collider as Node
		#if body and body.has_method("get_node"):
			#var health = body.get_node("HealthComponent")
			#if health:
				#health.damage(damage)
	
	
	cooldown_timer = firerate
	
	
