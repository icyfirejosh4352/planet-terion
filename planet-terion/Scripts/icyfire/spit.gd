extends Node2D

@onready var area_2d: Area2D = $Area2D
@export var Speed:float = 960.0

#func _ready() -> void:
	#print("borne")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position -= transform.y * Speed * delta
	pass
