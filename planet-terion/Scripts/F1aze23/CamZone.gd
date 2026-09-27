extends Node2D

@export var area:Area2D

func _process(delta: float) -> void:
	for i in area.get_overlapping_bodies():
		if i.is_in_group("Player"):
			var cam = i.get_node("CameraComponent")
			if cam != null:
				cam.switch(self)
