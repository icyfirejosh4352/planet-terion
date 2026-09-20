class_name Bullet
extends Node2D


@export var speed: float = 750
@export var damage: float = 10.0
@export var lifetime: float = 2.0

var velocity: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Bullet spawning at:", global_position)
	if velocity.length() > 0:
		rotation = velocity.angle()
	
	get_tree().create_timer(lifetime).timeout.connect(
		func() -> void:
			queue_free()
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position += velocity * delta
	
	if not get_viewport().get_visible_rect().has_point(global_position):
		queue_free()

func _on_body_entered(body: Node) -> void:
	var health = body.get_node("HealthComponent")
	if health:
		health.damage(damage)
		queue_free()
