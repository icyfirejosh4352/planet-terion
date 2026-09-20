class_name GameManager
extends Node

var level1 = preload("res://Scenes/randemlyy/Area1.tscn")
var mainMenu = preload("res://Scenes/F1aze23/mainMenu.tscn")
var gameOver = preload("res://Scenes/F1aze23/GameOverMenu.tscn")
var current_scene = null

func _ready():
	load_scene(mainMenu)

func load_scene(scene):
	var old_scene = null
	if current_scene != null:
		old_scene = current_scene
	current_scene = scene.instantiate()
	add_child(current_scene)
	if old_scene:
		for child in get_children():
			if child.name == old_scene.name:
				print(child.name)
				child.queue_free()
		remove_child(old_scene)

func quit_game():
	get_tree().quit()
	
func get_GM():
	return self
	
