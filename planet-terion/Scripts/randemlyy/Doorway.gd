extends Area2D

@export_file("*.tscn") var destination: String

var activated = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if activated or not body.is_in_group("Player"):
		return
	activated = true
	print("Doorway destination: ", destination)
	TransistionOverlay.change_room(destination)
	activated = false
