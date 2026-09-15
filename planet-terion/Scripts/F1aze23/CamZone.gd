extends Node2D

@export var area:Area2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var cam:= body.get_node("CameraComponent")
		if cam!=null:
			cam.switch(self)
		else:
			print("tf?")
