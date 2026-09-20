extends Node2D


var GM
func _ready() -> void:
	GM = get_node("/root/GameManager")

func _on_back_to_menu_pressed() -> void:
	GM.load_scene(GM.mainMenu)

func _on_quit_pressed() -> void:
	GM.quit_game()
