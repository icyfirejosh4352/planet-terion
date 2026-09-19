class_name AnimationComponent
extends Node

@export var anim:AnimationPlayer
@export var sprite:Sprite2D
var moveDir
var isMoving:= false
var isWeapon:=false
var isAttack:=false

func process(delta: float) -> void:
	if isAttack:
		anim.play("Attack-Sword")
		await anim.animation_finished
		isAttack = false
	elif isMoving:
		if moveDir == 1:
			sprite.flip_h = false
		else:
			sprite.flip_h = true
		if isWeapon:
			anim.play("Walk-Sword")
		else:
			anim.play("Walk-Base")
	else:
		if isWeapon:
			anim.play("Idle-Sword")
		else:
			anim.play("Idle-Base")
	
