extends Area2D

@export var Speed: float = 740.0
@export var Damage: float = 10.0
@export var Lifetime: float = 2.0
@export var knockback_force: float = 300.0

func _ready() -> void:
	get_tree().create_timer(Lifetime).timeout.connect(func() -> void: queue_free())

func _process(delta: float) -> void:
	position -= transform.y * Speed * delta
	for body in get_overlapping_bodies():
		if body.is_in_group("Player"):
			queue_free()  
			return
		var health = body.get_node_or_null("HealthComponent")
		if health:
			var bullet_dir = -transform.y.normalized()
			var knockback_dir = Vector2(sign(bullet_dir.x), 0)
			if knockback_dir.x == 0: knockback_dir.x = 1
			health.damage(Damage)
			
			HitEffectManager.trigger_hitstop(0.04)
			HitEffectManager.apply_knockback(body, knockback_dir, knockback_force)
			
			queue_free()
			return
		queue_free()
		return
