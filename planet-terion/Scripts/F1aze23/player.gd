extends CharacterBody2D
 
@export var input:InputComponent
@export var move:MovementComponent
@export var dash:DashComponent
@export var health:HealthComponent
@export var cam:CameraComponent

func _ready() -> void:
	health.ready()
	health.Death.connect(Death)
	cam.ready()

func _process(delta: float) -> void:
	move.speedMultiplier = dash.speedMultiplier
	move.dir = input.dir
	move.is_crouching = input.crouch
	dash.canDash = input.dash
	if input.jump:
		move.jump()
	dash.process(delta)
	health.process(delta)
	input.process(delta)
	cam.process(delta)

func _physics_process(delta: float) -> void:
	move.physics_process(delta)
	
func Death():
	print("dead")
