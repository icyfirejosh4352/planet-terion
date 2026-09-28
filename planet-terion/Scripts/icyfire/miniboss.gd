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
var rng = RandomNumberGenerator.new()
var randemlyy = 0
var Speed:float = 10.0
var TimeSinceRoll:float = 0
var RollTime:float = 0.2
@onready var dmgcol: Area2D = $dmgcol
var TimeSinceDmg:float = 0
var DmgTime:float = 1
var Dmg:float = 10.0
var AttackTime:float = 2
var TimeSinceSpit:float = 0
var SpitSpacing:float = 0.5
var KnockBackForce:float = 10.0
var player
@onready var SPIT = preload("uid://tps4qfrmupqc")
@onready var firepoint: Node2D = $Node2D2
var i = 0
@onready var WEAPON_PICKUP = preload("uid://bh31oo8pjus4q")

func _ready() -> void:
	boss_lever.activated_s.connect(_on_activation)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
#	print (BossState)
	if BossState == BossStates.REST:
		animation_player.play("rest")
		for obj in dmgcol.get_overlapping_bodies():
			if obj.is_in_group("Player"):
				player = obj
	elif BossState == BossStates.ACTIVATING:
		animation_player.play("wake up")
		await animation_player.animation_finished
		global_position.y = -100
		BossState = BossStates.ROAM
	elif BossState == BossStates.ROAM:
		TimeSinceDmg += delta
		TimeSinceRoll += delta
		velocity.x = Speed
		animation_player.play("walk")
		for obj in dmgcol.get_overlapping_bodies():
			if obj.is_in_group("Player") && TimeSinceDmg >= DmgTime:
				TimeSinceDmg = 0
				obj.get_node_or_null("HealthComponent").damage(10)
				obj.velocity.x = KnockBackForce
				player = obj
				break
		if TimeSinceRoll >= RollTime:
			TimeSinceRoll = 0
			randemlyy = rng.randi_range(0,9)
			if randemlyy == 5:
				BossState = BossStates.ATTACK_1
	elif BossState == BossStates.ATTACK_1:
		i += delta
		velocity.x = 0
		animation_player.play("shoot")
		var direction:Vector2 = player.global_position - firepoint.global_position
		TimeSinceSpit += delta
		if TimeSinceSpit>=SpitSpacing && player.get_node("HealthComponent").health >= 20:
			TimeSinceSpit = 0
			var new_bullet = SPIT.instantiate()
			new_bullet.global_position = firepoint.global_position
			new_bullet.global_rotation = direction.angle() + (PI/2)
			get_parent().add_child(new_bullet)
			print("bullet created")
		if i >= AttackTime:
			i = 0
			BossState = BossStates.ROAM
		if player.get_node("HealthComponent").health <= 20:
			BossState = BossStates.STOPPING
	elif BossState == BossStates.STOPPING:
		var PistolDrop = WEAPON_PICKUP.instantiate()
		PistolDrop.global_position = global_position
		PistolDrop.global_position.y += 80
		PistolDrop.weapon_scene = preload("uid://bffockmsld7qn")
		get_parent().add_child(PistolDrop)
		animation_player.play("leave")
		await animation_player.animation_finished
		queue_free()
	
	move_and_slide()
	
func _on_activation() -> void:
	BossState = BossStates.ACTIVATING
