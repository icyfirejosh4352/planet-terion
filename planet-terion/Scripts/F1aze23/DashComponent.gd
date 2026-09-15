class_name DashComponent
extends Node

@export var body : CharacterBody2D
@export var input:InputComponent
@export var move:MovementComponent
var speedMultiplier: = 1
const DASH_SPEED: = 670.0
var canDash:= false

func process(body: CharacterBody2D, move: MovementComponent):
	if canDash:
		# speedMultiplier = 6
		body.velocity.x = move.dir * DASH_SPEED
		print("dash")
	else:
		speedMultiplier = 1
