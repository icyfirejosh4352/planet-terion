extends CharacterBody2D
 
@export var input:InputComponent
@export var move:MovementComponent
@export var dash:DashComponent
@export var health:HealthComponent

func _ready() -> void:
	health.ready()
	health.Death.connect(Death)

func _process(delta: float) -> void:
	move.speedMultiplier = dash.speedMultiplier
	move.dir = input.dir
	dash.canDash = input.dash
	if input.jump:
		move.jump()
	dash.process()
	health.process(delta)
	input.process(delta)

func _physics_process(delta: float) -> void:
	move.physics_process(delta)
	
func Death():
	print("dead")
