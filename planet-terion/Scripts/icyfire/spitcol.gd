extends Area2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for body in get_overlapping_bodies():
		if body.is_in_group("Player"):
				body.get_node("HealthComponent").damage(20)
				print("ded")
				free()
		elif !body.is_in_group("spitter"):
			print("ded")
			free()
	pass
