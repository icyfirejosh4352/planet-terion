class_name AnimationComponent
extends Node

@export var anim:AnimationPlayer
@export var sprite:Sprite2D
var moveDir = 0
var isMoving:bool = false
var isWeapon:=false
var isAttack:=false
enum animType{PLAYER, CRAWLER}
var charType = animType.PLAYER

func process(delta: float) -> void:
	if charType == animType.PLAYER:
		if isAttack:
			anim.play("Attack-Sword")
			await anim.animation_finished
			isAttack = false
		elif isMoving:
			if isWeapon:
				anim.play("Walk-Sword")
			else:
				anim.play("Walk-Base")
		else:
			if isWeapon:
				anim.play("Idle-Sword")
			else:
				anim.play("Idle-Base")

	elif charType == animType.CRAWLER:
		if isAttack:
			anim.play("Attack")
			await anim.animation_finished
			isAttack = false
			print("hii")
		elif isMoving:
			anim.play("Walk")
		else:
			anim.play("Idle")
			
	if moveDir == 1:
		sprite.flip_h = false
	else:
		sprite.flip_h = true
			
	
