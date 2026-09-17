class_name InputComponent
extends Node

var dir:float
var jump: bool
var dash: bool
var crouch: bool
var attack: bool
var inv_next: bool
var inv_prev: bool

func process(delta: float) -> void:
	dir = Input.get_axis("Left", "Right")
	jump = Input.is_action_just_pressed("Jump")
	dash = Input.is_action_just_pressed("Dash")
	crouch = Input.is_action_pressed("Crouch")
	attack = Input.is_action_just_pressed("Attack")
	inv_next = Input.is_action_just_pressed("Inv_Next")
	inv_prev = Input.is_action_just_pressed("Inv_Prev")
