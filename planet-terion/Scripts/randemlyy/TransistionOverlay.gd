extends CanvasLayer

@onready var cover: ColorRect = $ScreenCover
var transistioning = false

func change_room(destination: String) -> void:
	if transistioning:
		return
	
	transistioning = true
	cover.mouse_filter = Control.MOUSE_FILTER_STOP
	
	var fade_out = create_tween()
	fade_out.tween_property(cover, "color:a", 1.0, 0.35)
	await  fade_out.finished
	
	var game_manager = get_node("/root/GameManager")
	game_manager.load_scene(destination)
	
	await get_tree().process_frame
	
	var fade_in = create_tween()
	fade_in.tween_property(cover, "color:a", 0.0, 0.35)
	await  fade_in.finished
	
	cover.mouse_filter = Control.MOUSE_FILTER_IGNORE
	transistioning = false
	
