class_name DashComponent
extends Node

var speedMultiplier: = 1
var canDash:= false

func process():
	if canDash:
		speedMultiplier = 4
		print("dash")
	else:
		speedMultiplier = 1
