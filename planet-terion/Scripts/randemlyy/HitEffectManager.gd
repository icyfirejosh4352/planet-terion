extends Node

func trigger_hitstop(duration: float = 0.06):
	Engine.time_scale = 0.05
	await get_tree().create_timer(duration * 0.05, true, false, true).timeout
	Engine.time_scale = 1.0

func apply_knockback(body: Node, direction: Vector2, force: float):
	if body.has_method("apply_hit_knockback"):
		body.apply_hit_knockback(direction * force)
	elif body is CharacterBody2D and "velocity" in body:
		body.velocity = direction * force
