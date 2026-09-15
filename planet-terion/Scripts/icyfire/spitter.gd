extends CharacterBody2D

@export var MoveSpeed:float = 50.0
@onready var player: CharacterBody2D = $"../Player"
@onready var detection_range: Area2D = $"Detection Range"
@onready var down_right_check: RayCast2D = $CollisionChecks/DownRightCheck
@onready var down_left_check: RayCast2D = $CollisionChecks/DownLeftCheck
@onready var left_check: RayCast2D = $CollisionChecks/LeftCheck
@onready var right_check: RayCast2D = $CollisionChecks/RightCheck
@onready var spitsc = preload("res://Scenes/icyfire/spit.tscn")

var IsChasing:bool = false
var MovingDir: float = 1
var TimeSinceDmg:float = 0
var DmgTime:float = 1
var TimeSinceSpit:float = 0
var SpitSpacing:float = 0.8
var TimeSinceRoll:float = 0
var RollSpacing:float = 0.2
var rng = RandomNumberGenerator.new()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	TimeSinceDmg += delta
	TimeSinceSpit += delta
	TimeSinceRoll += delta
	velocity.y += (get_gravity().y * delta)
	
	
	if IsChasing:
		var randemlyy
		var direction = (player.global_position - global_position).normalized()
		velocity.x = MoveSpeed * direction.x
		
		if TimeSinceRoll>RollSpacing:
			TimeSinceRoll = 0
			randemlyy = rng.randi_range(0,15)
			print(randemlyy)
			if randemlyy == 4:
				TimeSinceRoll = 0
				var new_bullet = spitsc.instantiate()
				new_bullet.global_position = self.global_position
				if direction.x > 0:
					new_bullet.global_rotation = self.global_rotation + PI/2
				elif direction.x < 0:
					new_bullet.global_rotation = self.global_rotation - PI/2
				get_parent().add_child(new_bullet)
				print("bullet made")
		
	elif !IsChasing && is_on_floor():
		if !left_check.is_colliding() && !right_check.is_colliding() && down_left_check.is_colliding() && down_right_check.is_colliding():
			pass
		else:
			print ("changing dir")
			if left_check.is_colliding() || !down_left_check.is_colliding():
				MovingDir = 1
			elif right_check.is_colliding() || !down_right_check.is_colliding():
				MovingDir = -1
				
		velocity.x = MoveSpeed * MovingDir

	for obj in detection_range.get_overlapping_bodies():
		if obj == player:
			IsChasing = true
			break
	move_and_slide()
	for i in get_slide_collision_count():
		if get_slide_collision(i).get_collider() == player && TimeSinceDmg>DmgTime:
			TimeSinceDmg = 0
			player.get_node("HealthComponent").damage(10)
