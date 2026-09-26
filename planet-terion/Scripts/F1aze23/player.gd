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
@export var weapon_label:Label
@onready var GM:GameManager
@onready var tutorial: Label = $Camera2D/UI/Control/Tutorial
@onready var tut_timer: Timer = $TutTimer
@onready var sprite = $Sprite2D

var equipped_weapon: Weapon: get = return_equipped
#func return_equipped(): return inventory.get_equipped()

func return_equipped():
	if inventory:
		return inventory.get_equipped()
	return null

func _ready() -> void:
	health.ready()
	health.Death.connect(Death)
	cam.ready()
	GM = get_node("/root/GameManager")
	anim.charType = anim.animType.PLAYER

	if not inventory:
		inventory = get_node("Inventory")
	
	if inventory:
		inventory.equipped_changed.connect(_on_equipped_changed)
		
	#var knife_scene = load("res://Scenes/randemlyy/Knife.tscn")
	#var pistol_scene = load("res://Scenes/randemlyy/Pistol.tscn")
	#knife = knife_scene.instantiate()
	#pistol = pistol_scene.instantiate()
	#knife.name = "Knife"
	#pistol.name = "Pistol"
	#add_child(knife)
	#add_child(pistol)
	#inventory.add_weapon(knife)
	#inventory.add_weapon(pistol)
	
	if inventory.get_equipped():
		weapon_label.text = "Equipped Weapon: %s" % inventory.get_equipped().name
	else:
		weapon_label.text = "Equipped Weapon: None"
	
	ShardBank.shards_changed.connect(_on_shard_changed)
	_on_shard_changed(ShardBank.shards)
		
	tut_timer.start()
	tut_timer.timeout.connect(tutorial.hide)

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
	if weapon_label:
		weapon_label.text = "Equipped Weapon: %s" % new_weapon.name
	else:
		push_warning("Weapon Label not set.")

func _on_shard_changed(total: int) -> void:
	$Camera2D/UI/Control/ShardLabel.text = "Shards: %d" % total

func pick_up_weapon(weapon_scene: PackedScene) -> void:
	if weapon_scene == null:
		return
	
	var weapon = weapon_scene.instantiate() as Weapon
	if weapon == null:
		push_warning('no wepaon')
		return
	add_child(weapon)
	inventory.add_weapon(weapon)

func _physics_process(delta: float) -> void:
	move.physics_process(delta)
	
func Death():
	GM.load_scene(GM.gameOver)
	
