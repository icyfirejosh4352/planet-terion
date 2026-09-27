class_name LevelManager
extends Node

var startPoint:Node2D
var parent:Node2D
var playerScene = load("res://Scenes/F1aze23/player.tscn")
var player:CharacterBody2D
var enemySpawner:Node

func _ready() -> void:
	parent = get_parent()
	for child in parent.get_children():
		if child.name == "StartPoint":
			startPoint=child
			
	if ResourceLoader.exists("res://SavedPlayer.tscn"):
		player = load("res://SavedPlayer.tscn").instantiate()
		parent.add_child.call_deferred(player)
		player.global_position = startPoint.global_position
		print("hello")
	elif startPoint:
		player = playerScene.instantiate()
		parent.add_child.call_deferred(player)
		player.global_position = startPoint.global_position
