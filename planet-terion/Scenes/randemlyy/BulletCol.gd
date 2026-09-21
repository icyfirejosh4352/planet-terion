extends Area2D

@export var Speed: float = 740.0
@export var Damage: float = 10.0
@export var Lifetime: float = 2.0

func _ready() -> void:
	get_tree().create_timer(Lifetime).timeout.connect(func() -> void: queue_free())

func _process(delta: float) -> void:
	position -= transform.y * Speed * delta
	for body in get_overlapping_bodies():
		if body.is_in_group("Player"):
			queue_free()  
			return
		var health = body.get_node("HealthComponent")
		if health:
			health.damage(Damage)
			queue_free()
			return
		queue_free()
		return
