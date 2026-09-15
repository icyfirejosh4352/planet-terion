class_name CameraComponent
extends Node

@export var cam: Camera2D
@export var smooth_speed: float = 5.0 

var current_zone: Node2D
var target_position: Vector2
var is_transitioning: bool = false

func ready() -> void:
	current_zone = get_tree().get_first_node_in_group("StartZone")
	if current_zone:
		target_position = current_zone.global_position
		cam.global_position = target_position
		cam.make_current()
		is_transitioning = false

func process(_delta: float) -> void:
	if current_zone:
		if is_transitioning:
			cam.global_position = cam.global_position.lerp(current_zone.global_position, smooth_speed * _delta)

			# Stop transitioning when close enough to target
			if cam.global_position.distance_to(current_zone.global_position) < 1.0:
				cam.global_position = current_zone.global_position
				is_transitioning = false
		else:
			cam.global_position = current_zone.global_position

func switch(new_zone: Node2D) -> void:
	if new_zone != current_zone:
		current_zone = new_zone
		is_transitioning = true
