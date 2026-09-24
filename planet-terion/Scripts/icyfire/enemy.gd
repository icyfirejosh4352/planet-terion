class_name Enemy
extends CharacterBody2D

@onready var healthComp: HealthComponent = $HealthComponent
@onready var detection_range: Area2D = $"Detection Range"
var player
var IsChasing:bool = false
var MovementSpeed:float = 100.0

enum EnemyStates
{
	IDLE,
	ROAMING,
	CHASING,
	KNOCKEDBACK,
	DYING
}
var S_EnemyState = EnemyStates.IDLE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func Enemy_process(delta: float) -> void:
	for obj in detection_range.get_overlapping_bodies():
		if obj.is_in_group("Player"):
			player = obj
			S_EnemyState = EnemyStates.CHASING
			break
	
	if healthComp.health <= 0:
		S_EnemyState = EnemyStates.DYING
		queue_free()

func knockback(direction:Vector2, damage:float, force:float) -> void:
#	S_EnemyState = EnemyStates.KNOCKEDBACK
	print(name, " knockback")
	var health = healthComp.health
	if health <= 0:
		return
	var HealthLostP:float = (damage/health) * 100
	print (HealthLostP)
	velocity.x = direction.x * force
