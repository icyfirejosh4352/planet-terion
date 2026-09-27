class_name AnimationComponent
extends Node

@export var anim:AnimationPlayer
@export var sprite:Sprite2D
var moveState = 0
var isMoving:bool = false
var isWeapon:=false
var isAttack:=false
var isJump:=false
enum animType{PLAYER, CRAWLER, THROWER}
enum moveDir{LEFT, RIGHT}
var movingDir = moveDir.RIGHT
var playerType:int
var charType = animType.PLAYER

func process(delta: float) -> void:
	if moveState == 3:
		isJump = true
	elif moveState == 2:
		sprite.flip_h = false
		isJump = false
		movingDir = moveDir.RIGHT
	elif moveState == 1:
		sprite.flip_h = true
		movingDir = moveDir.LEFT
		isJump = false
	else:
		if movingDir == moveDir.RIGHT:
			sprite.flip_h = false
		else:
			sprite.flip_h = true
		isJump = false


	if charType == animType.PLAYER:
		if playerType == 0:
			if isJump:
				anim.play("Jump-Base")
			elif isMoving:
				anim.play("Walk-Base")
			else:
				anim.play("Idle-Base")
		elif playerType == 1:
			if isAttack:
				anim.play("Attack-Gun")
				await anim.animation_finished
				isAttack = false
			elif isJump:
				anim.play("Jump-Gun")
			elif isMoving:
				anim.play("Walk-Gun")
			else:
				anim.play("Idle-Gun")
		elif playerType == 2:
			if isAttack:
				anim.play("Attack-Sword")
				await anim.animation_finished
				isAttack = false
			elif isJump:
				anim.play("Jump-Sword")
			elif isMoving:
				anim.play("Walk-Sword")
			else:
				anim.play("Idle-Sword")
				

	elif charType == animType.CRAWLER:
		if isAttack:
			anim.play("Attack")
			await anim.animation_finished
			isAttack = false
		elif isMoving:
			anim.play("Walk")
		else:
			anim.play("Idle")
			
	
