extends Area2D

@export var boss_scene: PackedScene
@onready var spawn_point: Marker2D
@onready var sprite: Sprite2D = $Sprite2D

var player_nearby = false
var activated = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.region_enabled = true
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if player_nearby and not activated and Input.is_action_just_pressed("Interact"):
		print("Activated! 1")
		activate()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_nearby = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_nearby = false

func activate() -> void:
	sprite.region_rect = Rect2(48, 160, 16, 16)
	print("Activated! 2")
