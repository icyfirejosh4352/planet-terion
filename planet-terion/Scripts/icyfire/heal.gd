extends Area2D


@export var HealAmt:int = 10


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print(body.name)
		body.get_node("HealthComponent").heal(HealAmt)
		self.get_parent().queue_free()
