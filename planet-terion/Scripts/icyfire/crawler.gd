extends Enemy

@export var MovementSpeedDiff: float = 60.0
@onready var down_right_check: RayCast2D = $CollisionChecks/DownRightCheck
@onready var down_left_check: RayCast2D = $CollisionChecks/DownLeftCheck
@onready var left_check: RayCast2D = $CollisionChecks/LeftCheck
@onready var right_check: RayCast2D = $CollisionChecks/RightCheck

var TimeSinceDmg:float = 0
var DmgTime:float = 1

var Lcheckcol:bool
var Rcheckcol:bool
var DLcheckcol:bool
var DRcheckcol:bool

var MovingDir:float = 1

func _process(delta: float) -> void:
#	print ("running")
	Enemy_process(delta)
	TimeSinceDmg += delta
	velocity.y += (get_gravity().y * delta)
	
	Lcheckcol = left_check.is_colliding()
	Rcheckcol = right_check.is_colliding()
	DLcheckcol = down_left_check.is_colliding()
	DRcheckcol = down_right_check.is_colliding()
	
	if IsChasing:
		var direction = (player.global_position - global_position).normalized()
		velocity.x = direction.x  * (MovementSpeed + MovementSpeedDiff)
	elif !IsChasing && is_on_floor():
		if !Lcheckcol && !Rcheckcol && DLcheckcol && DRcheckcol:
			pass
		else:
			if MovingDir == -1 && (Lcheckcol || !DLcheckcol):
				MovingDir = 1
			elif MovingDir == 1 && (Rcheckcol || !DRcheckcol):
				MovingDir = -1
		velocity.x = MovingDir * (MovementSpeed)
		
	move_and_slide()
	for i in get_slide_collision_count():
		if get_slide_collision(i).get_collider() == player && TimeSinceDmg>DmgTime:
			TimeSinceDmg = 0
			player.get_node("HealthComponent").damage(10)
