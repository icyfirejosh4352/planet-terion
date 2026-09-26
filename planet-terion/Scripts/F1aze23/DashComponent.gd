class_name DashComponent
extends Node

@export var input:InputComponent
@export var body:CharacterBody2D
@export var move:MovementComponent
@export var dash_cooldown: = 0.8
@export var dash_duration: = 0.15
@export var dash_deceleration := 0.15
@export var dash_speed_mult: = 4
@export var dash_streak_count: = 7
@export var dash_streak_length: = 34.0
@onready var sprite = $"../Sprite2D"

var speedMultiplier: = 1.0
var dash_timer: = 0.0
var decel_timer := 0.0
var dash_cooldown_timer: = 0.0
var canDash:= false
var has_used_air_dash:= false

func process(delta: float):
	if dash_timer > 0:
		dash_timer -= delta
	if decel_timer > 0:
		decel_timer -= delta
	if dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta
	
	if body.is_on_floor():
		has_used_air_dash = false
		
	if canDash and dash_cooldown_timer <= 0:
		if body.is_on_floor() or not has_used_air_dash:
			if not move.is_crouching:
				ScreenShakeManager.shake(0.5, 5.0, Vector2(10, 0))
				dash_timer = dash_duration
				decel_timer = dash_deceleration
				dash_cooldown_timer = dash_cooldown
				play_dash_feedback()
				start_ghost_chain()
				if not body.is_on_floor():
					has_used_air_dash = true
	
		
	if dash_timer > 0:
		speedMultiplier = dash_speed_mult
	elif decel_timer > 0:
		var t := decel_timer / dash_deceleration
		speedMultiplier = 1.0 + (dash_speed_mult - 1.0) * t
	else:
		speedMultiplier = 1.0
		

func start_ghost_chain():
	for i in range(5):
		if dash_timer <= 0:
			break
		spawn_ghost()
		await get_tree().create_timer(0.04).timeout

func spawn_ghost():
	if not sprite or not sprite.texture:
		return
	var ghost = Sprite2D.new()
	ghost.set_script(load("res://Scripts/randemlyy/Ghost.gd"))
	
	ghost.texture = sprite.texture
	ghost.hframes = sprite.hframes
	ghost.vframes = sprite.vframes
	ghost.frame = sprite.frame
	ghost.flip_h = sprite.flip_h
	ghost.global_position = sprite.global_position
	ghost.global_scale = sprite.global_scale
	ghost.modulate = Color(0.0, 0.6, 1.0, 0.6)
	get_tree().current_scene.add_child(ghost)
	ghost.global_position = sprite.global_position
	ghost.global_scale = sprite.global_scale

func play_dash_feedback() ->void:
	var dash_dir = sign(move.dir)
	if dash_dir == 0:
		dash_dir = sign(body.velocity.x)
	if dash_dir == 0:
		dash_dir = -1.0 if sprite.flip_h else 1.0
	var trail_dir = Vector2(-dash_dir, 0.0)
	var scene = get_tree().current_scene
	if scene == null:
		return
	
	for i in range(dash_streak_count):
		var streak = Line2D.new()
		streak.width = randf_range(1.5, 2.0)
		streak.default_color = Color(0.0, 0.6, 1.0, 0.6)
		streak.z_index = 5
		var start = body.global_position + Vector2(randf_range(-7.0, 7.0), randf_range(-18.0,18.0))
		streak.add_point(start)
		streak.add_point(start + trail_dir * randf_range(dash_streak_length * 0.5, dash_streak_length))
		scene.add_child(streak)
		var tween = streak.create_tween()
		tween.set_parallel(true)
		tween.tween_property(streak, "modulate:a", 0.0, 0.18)
		tween.tween_property(streak, "width", 0.0, 0.18)
		tween.chain().tween_callback(streak.queue_free)
	var tint_tween := sprite.create_tween()
	tint_tween.tween_property(sprite, "modulate", Color(0.45, 0.9, 1.0, 1.0), 0.035)
	tint_tween.tween_property(sprite, "modulate", Color.WHITE, 0.12)
