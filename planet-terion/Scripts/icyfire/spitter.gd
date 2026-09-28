extends Enemy

@export var MovementSpeedDiff: float = -50.0
@onready var down_right_check: RayCast2D = $CollisionChecks/DownRightCheck
@onready var down_left_check: RayCast2D = $CollisionChecks/DownLeftCheck
@onready var left_check: RayCast2D = $CollisionChecks/LeftCheck
@onready var right_check: RayCast2D = $CollisionChecks/RightCheck
@onready var spitsc = preload("res://Scenes/icyfire/spit.tscn")

@export var anim:AnimationComponent

var TimeSinceDmg:float = 0
var DmgTime:float = 1
var TimeSinceSpit:float = 0
var SpitSpacing:float = 0.8
var TimeSinceRoll:float = 0
var RollTime:float = 0.2
var rng = RandomNumberGenerator.new()

var Lcheckcol:bool
var Rcheckcol:bool
var DLcheckcol:bool
var DRcheckcol:bool

var MovingDir:float = 1

func _ready() -> void:
	anim.charType = anim.animType.THROWER

func _process(delta: float) -> void:
#	print ("running")
	anim.process(delta)
	Enemy_process(delta)
	TimeSinceDmg += delta
	TimeSinceRoll += delta
	TimeSinceSpit += delta
	velocity.y += (get_gravity().y * delta)
	
	Lcheckcol = left_check.is_colliding()
	Rcheckcol = right_check.is_colliding()
	DLcheckcol = down_left_check.is_colliding()
	DRcheckcol = down_right_check.is_colliding()
	
	
	if S_EnemyState != EnemyStates.KNOCKEDBACK:
		if S_EnemyState == EnemyStates.CHASING && is_on_floor():
			var randemlyy
			var direction = (player.global_position - global_position).normalized()
			velocity.x = direction.x  * (MovementSpeed + MovementSpeedDiff)
			
			if TimeSinceRoll>RollTime:
				TimeSinceRoll = 0
				randemlyy = rng.randi_range(0,9)
				if randemlyy == 4:
					anim.isAttack = true
					var new_bullet = spitsc.instantiate()
					new_bullet.global_position = self.global_position
					if direction.x > 0:
						new_bullet.global_rotation = self.global_rotation + PI/2
					elif direction.x < 0:
						new_bullet.global_rotation = self.global_rotation - PI/2
					get_parent().add_child(new_bullet)
			
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
	if velocity.x > 0:
		anim.movingDir = 0
	elif velocity.x < 0:
		anim.movingDir = 1
	if velocity.x != 0:
		anim.moveState = 1
	else:
		anim.moveState = 0

	for i in get_slide_collision_count():
		if get_slide_collision(i).get_collider() == player && TimeSinceDmg>DmgTime:
			TimeSinceDmg = 0
			anim.isAttack = true
			player.get_node("HealthComponent").damage(10)
			ScreenShakeManager.shake(0.5, 5.0, Vector2(40, 20))
