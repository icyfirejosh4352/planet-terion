class_name Enemy
extends CharacterBody2D

@onready var healthComp: HealthComponent = $HealthComponent
@onready var detection_range: Area2D = $"Detection Range"
var player
var IsChasing:bool = false
var MovementSpeed:float = 100.0

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func Enemy_process(delta: float) -> void:
	for obj in detection_range.get_overlapping_bodies():
		if obj == player:
			#print("Ischasing")
			IsChasing = true
			break
			
	if healthComp.health <= 0:
		free()
