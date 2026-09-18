extends CharacterBody2D

@export var MoveSpeed:float = 130.0
@onready var player: CharacterBody2D = $"../Player"
@onready var detection_range: Area2D = $"Detection Range"

var IsBlocking:bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	IsBlocking = false
	for obj in detection_range.get_overlapping_bodies():
		if obj.is_in_group("Player"):
			IsBlocking = true
	if IsBlocking:
		pass

	move_and_slide()
