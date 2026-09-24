class_name Enemy
extends CharacterBody2D

@onready var healthComp: HealthComponent = $HealthComponent
@onready var detection_range: Area2D = $"Detection Range"
var player
var IsChasing:bool = false
var MovementSpeed:float = 100.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func Enemy_process(delta: float) -> void:
	for obj in detection_range.get_overlapping_bodies():
		if obj.is_in_group("Player"):
			player = obj
			IsChasing = true
			break
	
	if healthComp.health <= 0:
		print("ded")
		queue_free()
