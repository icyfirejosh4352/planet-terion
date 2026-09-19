class_name MovementComponent
extends Node

@export var body : CharacterBody2D

@export var acceleration:= 300
@export var vel:= 90.0
@export var jump_vel:= -300.0
@export var speedMultiplier := 1.3
@export var coyote_time := 0.10
@export var _jump_buffer_time := 0.15 
@export var crouch_speed_mult := 0.4
@export var jump_cutoff = 0.5

var dir:float
var _coyote_timer := 0.0
var _jump_buffer_timer := 0.0
var _was_on_floor := false
var is_crouching := false

var isMoving := false
enum MoveDir{left, right}
var moveDir:MoveDir

func physics_process(delta: float) -> void:
	if body.is_on_floor():
		_coyote_timer = coyote_time
		_was_on_floor = true
		body.velocity.y += body.get_gravity().y/150
	else:
		if _was_on_floor:
			_was_on_floor = false 
		_coyote_timer = max(0.0, _coyote_timer - delta) # count down
		
		body.velocity.y += body.get_gravity().y/60
	
	if Input.is_action_just_pressed("Jump"):
		_jump_buffer_timer = _jump_buffer_time
	else:
		_jump_buffer_timer = max(0.0, _jump_buffer_timer - delta)
	
	if Input.is_action_just_released("Jump") and body.velocity.y < 0:
		body.velocity.y *= jump_cutoff
	
	var current_vel = vel
	if is_crouching:
		current_vel *= crouch_speed_mult
		
	if dir == 0:
		body.velocity.x = move_toward(body.velocity.x, 0, acceleration)
	else:
		if speedMultiplier == 1:
			body.velocity.x = move_toward(body.velocity.x, dir * current_vel , acceleration)
		else:
			body.velocity.x = dir*current_vel*speedMultiplier
	
	body.move_and_slide()
	if body.velocity != Vector2.ZERO:
		isMoving = true
		if body.velocity.x > 0:
			moveDir = MoveDir.left
		else:
			moveDir = MoveDir.right
	else:
		isMoving = false
	
func jump():
	if body.is_on_floor() or _coyote_timer > 0.0:
		body.velocity.y = jump_vel
