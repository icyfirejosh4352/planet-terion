extends Area2D


func _process(delta: float) -> void:
	for i in get_overlapping_bodies():
		if i.is_in_group("Player"):
			var start = get_parent().get_children()
			for j in start:
				if j.name == "StartPoint":
					j.name = "notStartPoint"
					self.name = "StartPoint"
			var node_to_save = get_parent()
			var scene = PackedScene.new()
			var player = PackedScene.new()
			scene.pack(node_to_save)
			player.pack(i)
			ResourceSaver.save(scene, "res://SaveFile.tscn")
			ResourceSaver.save(player, "res://SavedPlayer.tscn")
			print("saved")
