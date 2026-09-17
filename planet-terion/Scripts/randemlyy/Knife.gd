class_name Knife
extends Weapon

@onready var attack_visual: Node2D = $AttackVisual
@export var attack_range: float = 32.0   # pixels
@export var attack_width: float = 16.0   # pixels

func attack(direction: Vector2) -> void:
	if not can_attack():
		return
	if attack_visual:
		attack_visual.visible = true
		attack_visual.modulate = Color(1, 0, 0, 0.5)
		get_tree().create_timer(0.1).timeout.connect(
			func(): if is_instance_valid(attack_visual): attack_visual.visible = false
		)
	
	var dir = direction.normalized()
	if abs(dir.x) > abs(dir.y):
		dir.x = sign(dir.x)
		dir.y = 0
	else:
		dir.x = 0
		dir.y = sign(dir.y)
	
	var offset = dir * (attack_range / 2.0)
	var rect_size = Vector2(attack_range,attack_width)
	
	if dir.x != 0:
		rect_size = Vector2(attack_range, attack_width)
	else:
		rect_size = Vector2(attack_width, attack_range)
	
	var shape = RectangleShape2D.new()
	shape.size = rect_size
	
	var space = get_viewport().get_world_2d().direct_space_state
	var params = PhysicsShapeQueryParameters2D.new()
	params.shape = shape
	params.transform = Transform2D(0, global_position + offset)
	params.collide_with_bodies = true
	params.collide_with_areas = true
	
	var results = space.intersect_shape(params)
	for r in results:
		var body = r.collider as Node
		if body and body.has_method("get_node"):
			if body == self or body == self.get_parent():
				continue
			var health = body.get_parent().get_node("HealthComponent")
			if health:
				health.damage(damage)
	
	cooldown_timer = firerate
