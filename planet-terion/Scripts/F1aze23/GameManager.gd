class_name GameManager
extends Node

var level1 = preload("res://Scenes/randemlyy/Area1.tscn")
var mainMenu = preload("res://Scenes/F1aze23/mainMenu.tscn")
var gameOver = preload("res://Scenes/F1aze23/GameOverMenu.tscn")
var levelTransistion = preload("res://Scenes/randemlyy/TransistionOverlay.tscn")
var current_scene = null

func _ready():
	load_scene(mainMenu)

func load_scene(scene):
	if scene == null:
		push_error("Attempted to load a null scene in GameManager.load_scene")
		return
	
	var scene_to_instantiate: PackedScene = null
	
	if scene is String:
		if scene == "":
			push_error("Attempted to load an empty scene path string!")
			return
		scene_to_instantiate = load(scene) as PackedScene
	elif scene is PackedScene:
		scene_to_instantiate = scene
		
	if scene_to_instantiate == null:
		return
	
	var new_scene = scene_to_instantiate.instantiate()
	var old_scene = current_scene
	
	add_child(new_scene)
	current_scene = new_scene
	
	if old_scene != null:
		old_scene.queue_free()
	
	#var old_scene = null
	#if current_scene != null:
		#old_scene = current_scene
	#current_scene = scene.instantiate()
	#add_child(current_scene)
	#if old_scene:
		#for child in get_children():
			#if child.name == old_scene.name:
				#print(child.name)
				#child.queue_free()
		#remove_child(old_scene)

func quit_game():
	get_tree().quit()
	
func get_GM():
	return self
	
