class_name InputComponent
extends Node

var dir:float
var jump: bool
var dash: bool

func process(delta: float) -> void:
	dir = Input.get_axis("Left", "Right")
	jump = Input.is_action_just_pressed("Jump")
	dash = Input.is_action_just_pressed("Dash")
