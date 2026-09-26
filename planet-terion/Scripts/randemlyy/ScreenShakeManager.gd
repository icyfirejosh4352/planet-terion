extends Node

var trauma: float = 0.0
var decay: float = 0.8
var max_offset: Vector2 = Vector2(50, 50)
var trauma_power: int = 2

func shake(amount: float = 0.4, custom_decay: float = 0.8, custom_offset: Vector2 = Vector2(50, 50)):
	trauma = min(trauma + amount, 1.0)
	decay = custom_decay
	max_offset = custom_offset

func _process(delta: float):
	if trauma <= 0:
		return
		
	trauma = max(trauma - decay * delta, 0.0)
	
	# Automatically get the current active 2D camera
	var camera = get_viewport().get_camera_2d()
	if camera:
		if trauma > 0:
			var shake_strength = pow(trauma, trauma_power)
			camera.offset = Vector2(
				randf_range(-max_offset.x, max_offset.x),
				randf_range(-max_offset.y, max_offset.y)
			) * shake_strength
		else:
			camera.offset = Vector2.ZERO
