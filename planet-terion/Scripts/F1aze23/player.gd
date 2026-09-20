extends CharacterBody2D
 
@export var input:InputComponent
@export var move:MovementComponent
@export var dash:DashComponent
@export var health:HealthComponent
@export var cam:CameraComponent
@export var inventory:Inventory
@export var anim:AnimationComponent
@export var knife:Knife
@export var pistol:Pistol
@onready var GM:GameManager


var equipped_weapon: Weapon: get = return_equipped
func return_equipped(): return inventory.get_equipped()

func _ready() -> void:
	health.ready()
	health.Death.connect(Death)
	cam.ready()
	GM = get_node("/root/GameManager")
	
	if not inventory:
		inventory = get_node("Inventory")
	
	if inventory:
		inventory.equipped_changed.connect(_on_equipped_changed)
		
	var knife_scene = load("res://Scenes/randemlyy/Knife.tscn")
	var pistol_scene = load("res://Scenes/randemlyy/Pistol.tscn")
	knife = knife_scene.instantiate()
	pistol = pistol_scene.instantiate()
	knife.name = "Knife"
	pistol.name = "Pistol"
	add_child(knife)
	add_child(pistol)
	inventory.add_weapon(knife)
	inventory.add_weapon(pistol)


func _process(delta: float) -> void:
	move.speedMultiplier = dash.speedMultiplier
	move.dir = input.dir
	move.is_crouching = input.crouch
	dash.canDash = input.dash
	anim.isMoving = move.isMoving
	anim.moveDir = move.moveDir
	if input.jump:
		move.jump()
	dash.process(delta)
	health.process(delta)
	input.process(delta)
	cam.process(delta)
	anim.process(delta)
	
	if equipped_weapon:
		equipped_weapon._process(delta)
		anim.isWeapon = true
	else:
		anim.isWeapon = false
	
	if input.attack:
		if equipped_weapon and equipped_weapon.can_attack():
			var aim_dir = Vector2.ZERO
			if move.moveDir == 1:
				aim_dir = Vector2(-1, 0.0)
			else:
				aim_dir = Vector2(1, 0.0)
			equipped_weapon.attack(aim_dir)
			anim.isAttack = true
	
	if input.inv_next:
		inventory.next_weapon()
	if input.inv_prev:
		inventory.prev_weapon()
		
func _on_equipped_changed(new_weapon: Weapon) -> void:
	print("Equipped weapon: %s" % new_weapon.name)
	
func _physics_process(delta: float) -> void:
	move.physics_process(delta)
	
func Death():
	GM.load_scene(GM.gameOver)
