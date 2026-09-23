extends GPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	emitting = true
	
	await get_tree().create_timer(lifetime + 0.1).timeout
	queue_free()
