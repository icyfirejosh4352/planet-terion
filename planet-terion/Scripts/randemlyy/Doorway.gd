extends Area2D

@export_file("*.tscn") var destination: String

var activated = false
@export var final:=false
var dir = DirAccess.open("res://")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if activated or not body.is_in_group("Player"):
		return
	activated = true
	if final == true:
		if ResourceLoader.exists("res://SavedPlayer.tscn"):
			var error = dir.remove("SavedPlayer.tscn")
			if error == OK:
				print("Scene deleted successfully!")
			else:
				print("Failed to delete scene. Error code: ", error)
		else:
			print("File does not exist.")
		if ResourceLoader.exists("res://SaveFile.tscn"):
			var error = dir.remove("SaveFile.tscn")
			if error == OK:
				print("Scene deleted successfully!")
			else:
				print("Failed to delete scene. Error code: ", error)
		else:
			print("File does not exist.")
	else:
		var player = PackedScene.new()
		player.pack(body)
		ResourceSaver.save(player, "res://SavedPlayer.tscn")
	print("Doorway destination: ", destination)
	TransistionOverlay.change_room(destination)
	activated = false
