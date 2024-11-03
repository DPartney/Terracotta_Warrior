extends Control

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
		pass


func _on_start_button_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	get_tree().change_scene_to_file("res://Scenes/map.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
