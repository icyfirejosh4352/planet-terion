class_name Pistol
extends Weapon

@export var bullet_range: float = 256.0
@export var bullet_speed: float = 500.0
@export var bullet_width: float = 8.0

func attack(direction: Vector2) -> void:
	if not can_attack():
		return
	
	var dir = direction.normalized()
	if dir.length() == 0:
		return
	
	var bullet_scene = load("res://Scenes/randemlyy/Bullet.tscn")
	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	print(">>> Bullet instance created:", bullet)
	
	bullet.global_position = global_position
	bullet.rotation = dir.angle()
	
	bullet.velocity = dir * bullet_speed
	bullet.damage = damage
	
	
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
	
	
