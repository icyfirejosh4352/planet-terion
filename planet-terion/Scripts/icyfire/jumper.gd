extends Enemy

@export var MovementSpeedDiff: float = 20.0
@export var JumpSpeed:float = -600.0
@onready var down_right_check: RayCast2D = $CollisionChecks/DownRightCheck
@onready var down_left_check: RayCast2D = $CollisionChecks/DownLeftCheck
@onready var left_check: RayCast2D = $CollisionChecks/LeftCheck
@onready var right_check: RayCast2D = $CollisionChecks/RightCheck

var TimeSinceDmg:float = 0
var DmgTime:float = 1
var TimeSinceJump:float = 0
var JumpTime:float = 2

var Lcheckcol:bool
var Rcheckcol:bool
var DLcheckcol:bool
var DRcheckcol:bool

var MovingDir:float = 1

func _process(delta: float) -> void:
#	print ("running")
	Enemy_process(delta)
	TimeSinceDmg += delta
	TimeSinceJump += delta
	velocity.y += (get_gravity().y * delta)
	
	Lcheckcol = left_check.is_colliding()
	Rcheckcol = right_check.is_colliding()
	DLcheckcol = down_left_check.is_colliding()
	DRcheckcol = down_right_check.is_colliding()
	
	if S_EnemyState != EnemyStates.KNOCKEDBACK:
		if S_EnemyState == EnemyStates.CHASING:
			var direction = (player.global_position - global_position).normalized()
			if is_on_floor():
				velocity.x = (MovementSpeed + MovementSpeedDiff) * direction.x
			else:
				velocity.x = (MovementSpeed + MovementSpeedDiff) * direction.x * 2

			if player.global_position.y  - 1 < global_position.y && TimeSinceJump>JumpTime && is_on_floor():
	#			print("Jump")
				TimeSinceJump = 0
				velocity.y = JumpSpeed
		elif S_EnemyState != EnemyStates.CHASING && is_on_floor():
			if !Lcheckcol && !Rcheckcol && DLcheckcol && DRcheckcol:
				pass
			else:
				#print ("changing dir")
				if left_check.is_colliding() || !down_left_check.is_colliding():
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
