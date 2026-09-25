class_name Enemy
extends CharacterBody2D

@onready var healthComp: HealthComponent = $HealthComponent
@onready var detection_range: Area2D = $"Detection Range"
var player
var IsChasing:bool = false
var MovementSpeed:float = 100.0

var TimeSinceKnockback:float = 0
var KnockbackTime:float = 0.8
var KnockbackSmooth:float = 0.5

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
	if healthComp.health <= 0:
		S_EnemyState = EnemyStates.DYING
		queue_free()
	
	if S_EnemyState == EnemyStates.KNOCKEDBACK:
		TimeSinceKnockback += delta
		velocity.x = lerp(velocity.x, 0.0, KnockbackSmooth)
		if TimeSinceKnockback >= KnockbackTime:
			TimeSinceKnockback = 0
			S_EnemyState = EnemyStates.ROAMING
		return
	for obj in detection_range.get_overlapping_bodies():
		if obj.is_in_group("Player"):
			player = obj
			IsChasing = true
			break
	
	

func knockback(direction:Vector2, damage:float, force:float) -> void:
	S_EnemyState = EnemyStates.KNOCKEDBACK
#	print(name, " knockback")
	var health = healthComp.health
	if health <= 0:
		return
	var HealthLostP:float = (damage/health) * 100
#	print (HealthLostP)
#	print(direction.x * force)
	velocity.x = -direction.x * force * HealthLostP
