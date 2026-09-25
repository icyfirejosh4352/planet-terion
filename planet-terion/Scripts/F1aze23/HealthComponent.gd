class_name HealthComponent
extends Node

signal damaged(amount: float)
@export var healthBar: ProgressBar
@export var health:= 100.0
@export var health_smooth_speed: float = 8.0
signal Death
var _target_health: float = 100.0

func ready():
	healthBar.max_value = health
	_target_health = health

func process(delta: float) -> void:
	_target_health = health
	healthBar.value = lerp(healthBar.value, _target_health, health_smooth_speed*delta)

	if health>100:
		health = 100
	if health <= 0:
		Death.emit()
	#healthBar.value = health

func heal(amt:float):
	health+=amt
	
func damage(amt:float):
	health-=amt
	damaged.emit(amt)
