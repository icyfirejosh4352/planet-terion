extends Area2D

@export var Speed: float = 740.0
@export var Damage: float = 5.0
@export var Lifetime: float = 2.0
@export var knockback_force: float = 300.0
@onready var impact = preload("res://Scenes/randemlyy/ImpactEffect.tscn")


func _process(delta: float) -> void:
	#position -= transform.y * Speed * delta
	
	for body in get_overlapping_bodies():
		if body != null && !body.is_in_group("Player"):
			if body.get_node_or_null("HealthComponent") != null:
				var bullet_dir = -transform.y.normalized()
				var knockback_dir = Vector2(sign(bullet_dir.x), 0)
				if knockback_dir.x == 0: knockback_dir.x = 1
				body.get_node("HealthComponent").damage(Damage)
				
				##var impact = preload("res://Scenes/randemlyy/ImpactEffect.tscn").instantiate()
				##impact.global_position = global_position
				##get_tree().current_scene.add_child(impact)
				
				HitEffectManager.trigger_hitstop(0.04)
#				HitEffectManager.apply_knockback(body, knockback_dir, knockback_force)
				body.knockback(knockback_dir, Damage, knockback_force)
			self.get_parent().queue_free()
