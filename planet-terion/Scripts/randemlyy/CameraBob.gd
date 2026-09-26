extends Camera2D

@export var bob_frequency: float =  16.0
@export var bob_amplitude: Vector2 = Vector2(0.4, 0.4)
@export var return_speed: float = 10.0

var bob_time: float = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var parent = get_parent()
	
	if parent and parent is CharacterBody2D and parent.is_on_floor() and parent.velocity.length() > 10.0:
		bob_time += delta * bob_frequency
		
		var target_x = sin(bob_time * 0.5) * bob_amplitude.x
		var target_y = sin(bob_time) * bob_amplitude.y
		
		offset.x = lerp(offset.x, target_x, delta * return_speed)
		offset.y = lerp(offset.y, target_y, delta * return_speed)
	else:
		bob_time = 0.0
		offset = offset.lerp(Vector2.ZERO, delta * return_speed)
		
