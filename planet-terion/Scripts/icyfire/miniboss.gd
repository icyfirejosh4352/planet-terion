extends CharacterBody2D

enum BossStates
{
	REST,
	ACTIVATING,
	ROAM,
	ATTACK_1,
	ATTACK_2,
	ATTACK_3,
	STOPPING
}
var BossState = BossStates.REST
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var boss_lever: Area2D = $"../TileMaps/BossLever"

var Speed:float = 50.0


func _ready() -> void:
	boss_lever.activated_s.connect(_on_activation)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
#	print (BossState)
	if BossState == BossStates.REST:
		animation_player.play("rest")
		#for obj in detection_range.get_overlapping_bodies():
			#if obj.is_in_group("Player"):
				#BossState = BossStates.ACTIVATING
				#break
	elif BossState == BossStates.ACTIVATING:
		animation_player.play("wake up")
		await animation_player.animation_finished
		global_position.y = -110
		BossState = BossStates.ROAM
	elif BossState == BossStates.ROAM:
		velocity.x = Speed
		animation_player.play("walk")
	move_and_slide()
	
func _on_activation() -> void:
	BossState = BossStates.ACTIVATING
