extends CharacterBody2D
 
@export var input:InputComponent
@export var move:MovementComponent

func _physics_process(delta: float) -> void:
	move.dir = input.dir
	if input.jump:
		move.jump()
	input.process(delta)
	move.physics_process(delta)
