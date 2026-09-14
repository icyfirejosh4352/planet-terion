class_name MovementComponent
extends Node

@export var body : CharacterBody2D
var dir:float
var acceleration:= 10
var vel:= 160.0
var jump_vel:= -320.0
var speedMultiplier = 1


func physics_process(delta: float) -> void:
	if body.is_on_floor():
		body.velocity.y += body.get_gravity().y/150
	else:
		body.velocity.y += body.get_gravity().y/100
	
	if dir == 0:
		body.velocity.x = move_toward(body.velocity.x, 0, acceleration)
	else:
		if speedMultiplier == 1:
			body.velocity.x = move_toward(body.velocity.x, dir * vel , acceleration)
		else:
			body.velocity.x = dir*vel*speedMultiplier
	
	body.move_and_slide()
	
func jump():
	if body.is_on_floor():
		body.velocity.y = jump_vel
