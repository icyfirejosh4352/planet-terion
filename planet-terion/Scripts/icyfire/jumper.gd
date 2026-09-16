extends CharacterBody2D

@export var MoveSpeed:float = 100.0
@export var JumpSpeed:float= -600.0
@onready var player: CharacterBody2D = $"../Player"
@onready var detection_range: Area2D = $"Detection Range"
@onready var down_right_check: RayCast2D = $CollisionChecks/DownRightCheck
@onready var down_left_check: RayCast2D = $CollisionChecks/DownLeftCheck
@onready var left_check: RayCast2D = $CollisionChecks/LeftCheck
@onready var right_check: RayCast2D = $CollisionChecks/RightCheck

var IsChasing:bool = false
var MovingDir: float = 1
var TimeSinceDmg:float = 0
var DmgTime:float = 1
var TimeSinceJump:float = 0
var JumpSpacing:float = 2
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	TimeSinceDmg += delta
	TimeSinceJump += delta
	velocity.y += (get_gravity().y * delta)

	if IsChasing:
		var direction = (player.global_position - global_position).normalized()
		if is_on_floor():
			velocity.x = MoveSpeed * direction.x
		else:
			velocity.x = MoveSpeed * direction.x * 2
		if player.global_position.y  + 1 < global_position.y && TimeSinceJump>JumpSpacing && is_on_floor():
			print("Jump")
			TimeSinceJump = 0
			velocity.y = JumpSpeed
	elif !IsChasing && is_on_floor():
		if !left_check.is_colliding() && !right_check.is_colliding() && down_left_check.is_colliding() && down_right_check.is_colliding():
			pass
		else:
			print ("changing dir")
			if left_check.is_colliding() || !down_left_check.is_colliding():
				MovingDir = 1
			elif right_check.is_colliding() || !down_right_check.is_colliding():
				MovingDir = -1
				
		velocity.x = MoveSpeed/2 * MovingDir

	for obj in detection_range.get_overlapping_bodies():
		if obj == player:
			IsChasing = true
			break
	move_and_slide()
	for i in get_slide_collision_count():
		if get_slide_collision(i).get_collider() == player && TimeSinceDmg>DmgTime:
			TimeSinceDmg = 0
			player.get_node("HealthComponent").damage(10)
