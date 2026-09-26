extends Enemy

@export var MovementSpeedDiff: float = 30.0
var knockback_velocity: Vector2 = Vector2.ZERO
@export var knockback_friction: float = 10.0 
@onready var down_right_check: RayCast2D = $CollisionChecks/DownRightCheck
@onready var down_left_check: RayCast2D = $CollisionChecks/DownLeftCheck
@onready var left_check: RayCast2D = $CollisionChecks/LeftCheck
@onready var right_check: RayCast2D = $CollisionChecks/RightCheck

@export var anim:AnimationComponent

var TimeSinceDmg: float = 0
var DmgTime: float = 1

var Lcheckcol: bool
var Rcheckcol: bool
var DLcheckcol: bool
var DRcheckcol: bool

var MovingDir: float = 1

func _ready() -> void:
	anim.charType = anim.animType.CRAWLER

func _process(delta: float) -> void:
	anim.process(delta)
	Enemy_process(delta)
	TimeSinceDmg += delta
	velocity.y += (get_gravity().y * delta)
	
	Lcheckcol = left_check.is_colliding()
	Rcheckcol = right_check.is_colliding()
	DLcheckcol = down_left_check.is_colliding()
	DRcheckcol = down_right_check.is_colliding()
	
#	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, knockback_friction * delta * 100)
	
	for i in get_slide_collision_count():
		if get_slide_collision(i).get_collider() == player && TimeSinceDmg > DmgTime:
			TimeSinceDmg = 0
			anim.isAttack = true
			player.get_node("HealthComponent").damage(10)
			ScreenShakeManager.shake(0.5, 5.0, Vector2(40, 20))
	
	if S_EnemyState == EnemyStates.KNOCKEDBACK:
		pass
	else:
		if !anim.isAttack:
			if S_EnemyState == EnemyStates.CHASING:
				anim.isMoving = true
				var direction = (player.global_position - global_position).normalized()
				velocity.x = direction.x  * (MovementSpeed + MovementSpeedDiff)
				if direction.x > 0:
					anim.moveDir = 0
				elif direction.x < 0:
					anim.moveDir = 1
			elif !S_EnemyState == EnemyStates.CHASING && is_on_floor():
				if !Lcheckcol && !Rcheckcol && DLcheckcol && DRcheckcol:
					pass
				else:
					if left_check.is_colliding() || !down_left_check.is_colliding():
						if MovingDir == -1 && (Lcheckcol || !DLcheckcol):
							MovingDir = 1
							anim.moveDir = 0
						elif MovingDir == 1 && (Rcheckcol || !DRcheckcol):
							MovingDir = -1
							anim.moveDir = 1
				velocity.x = MovingDir * (MovementSpeed)
				anim.isMoving = true
			else:
				anim.isMoving = false
	
	move_and_slide()

#func apply_hit_knockback(force: Vector2) -> void:
#	knockback_velocity = force
