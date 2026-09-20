extends Node2D

var GM
func _ready() -> void:
	GM = get_node("/root/GameManager")
	
func _on_start_pressed() -> void:
	GM.load_scene(GM.level1)


func _on_quit_pressed() -> void:
	GM.quit_game()
