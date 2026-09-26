extends Node2D

@onready var area_2d: Area2D = $Area2D
@export var Speed:float = 200.0

func _process(delta: float) -> void:
	position += transform.x * Speed * delta
	pass
