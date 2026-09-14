class_name HealthComponent
extends Node

@export var healthBar: ProgressBar
var health:= 100.0
signal Death

func ready():
	healthBar.max_value = health

func process(delta: float) -> void:
	if health>100:
		health = 100
	if health <= 0:
		Death.emit()
	healthBar.value = health

func heal(amt:float):
	health+=amt
	
func damage(amt:float):
	health-=amt
