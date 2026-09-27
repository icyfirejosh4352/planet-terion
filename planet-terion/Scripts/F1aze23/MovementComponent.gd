class_name MovementComponent
extends Node

@export var body : CharacterBody2D

@export var acceleration:= 1500.0
@export var air_acceleration:= 1400.0
@export var braking:= 1800.0
@export var air_braking:= 1200.0
@export var vel:= 115.0
@export var jump_vel:= -170.0
@export var speedMultiplier := 1.3
@export var coyote_time := 0.10
@export var _jump_buffer_time := 0.15 
@export var crouch_speed_mult := 0.4
@export var jump_cutoff = 0.5

var dir:float
var _coyote_timer := 0.0
var _jump_buffer_timer := 0.0
var is_crouching := false

var isMoving :bool = false

enum move{STANDING, WALK, JUMP}
var moveState := move.WALK
var animDir:=0

func physics_process(delta: float) -> void:
	var grounded:= body.is_on_floor()
	
	if grounded:
		_coyote_timer = coyote_time
		if body.velocity.y > 0.0:
			body.velocity.y = 0
	else:
		_coyote_timer = maxf(_coyote_timer-delta, 0.0)
		body.velocity += body.get_gravity() * delta
	
	_jump_buffer_timer = maxf(_jump_buffer_timer - delta, 0.0)
	if _jump_buffer_timer > 0.0 and _coyote_timer > 0.0:
		body.velocity.y = jump_vel
		_jump_buffer_timer = 0.0
		_coyote_timer = 0.0
		grounded = false
	
	var target_speed = vel * maxf(speedMultiplier, 0.0)
	if is_crouching:
		target_speed *= crouch_speed_mult
	
	var target_x : float = dir * target_speed
	var rate: float
	if is_zero_approx(dir):
		if grounded:
			rate = braking
		else:
			rate = air_braking
	else:
		if grounded:
			rate = acceleration
		else:
			rate = air_acceleration
	
	if speedMultiplier > 1.0 and not is_zero_approx(dir):
		body.velocity.x = dir * target_speed
	else:
		body.velocity.x = move_toward(
			body.velocity.x,
			target_x,
			rate * delta
		)
	
	if Input.is_action_just_released("Jump") and body.velocity.y < 0.0:
		body.velocity.y *= jump_cutoff
	
	body.move_and_slide()
	isMoving = not is_zero_approx(body.velocity.x)


func process():
	if !body.is_on_floor():
		moveState = move.JUMP
	else:
		if dir != 0:
			moveState = move.WALK
		elif dir == 0:
			moveState = move.STANDING
	if dir > 0:
		animDir = 0
	elif dir < 0:
		animDir = 1
func jump():
	_jump_buffer_timer = _jump_buffer_time
	#if body.is_on_floor() or _coyote_timer > 0.0:
		#body.velocity.y = jump_vel
