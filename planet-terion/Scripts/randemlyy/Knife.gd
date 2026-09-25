class_name Knife
extends Weapon

@export var attack_range: float = 32.0   # pixels
@export var attack_width: float = 16.0   # pixels
@export var knockback_force: float = 28.0 # Heavy melee punch impact
@onready var audio_stream_player: AudioStreamPlayer = $"../AudioStreamPlayer"


func attack(direction: Vector2) -> void:
	if not can_attack():
		return
	
	audio_stream_player.play()
	
	var dir = direction.normalized()
	if abs(dir.x) > abs(dir.y):
		dir.x = sign(dir.x)
		dir.y = 0
	else:
		dir.x = 0
		dir.y = sign(dir.y)
	
	var offset = dir * (attack_range / 2.0)
	var rect_size = Vector2(attack_range,attack_width)
	
	if dir.x != 0:
		rect_size = Vector2(attack_range, attack_width)
	else:
		rect_size = Vector2(attack_width, attack_range)
		
	var shape = RectangleShape2D.new()
	shape.size = rect_size
	
	var space = get_viewport().get_world_2d().direct_space_state
	var params = PhysicsShapeQueryParameters2D.new()
	params.shape = shape
	params.transform = Transform2D(0, global_position + offset)
	params.collide_with_bodies = true
	params.collide_with_areas = false
	
	var results = space.intersect_shape(params)
	var hit_anything = false
	for r in results:
		var body = r.collider as Node
		if body and body.has_method("get_node"):
			if body == self or body == self.get_parent():
				continue
			if body.has_node("HealthComponent"):		
				var health = body.get_node("HealthComponent")
				health.damage(damage)
				
				var knockback_dir = -(body.global_position - self.get_parent().global_position).normalized()
				body.knockback(knockback_dir, damage, knockback_force)
				#HitEffectManager.apply_knockback(body, knockback_dir, knockback_force)
				hit_anything = true
	
	if hit_anything:
		HitEffectManager.trigger_hitstop(0.08) 
		ScreenShakeManager.shake(0.5, 4.0, Vector2(25, 2)) 
	
	cooldown_timer = knife_firerate
