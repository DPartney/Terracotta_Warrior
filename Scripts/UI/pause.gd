extends Control

@onready var menu := $"."

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (Input.is_action_pressed("Pause")):
		menu.show()
		get_tree().paused = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _on_resume_button_pressed() -> void:
	menu.hide()
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	get_tree().paused = false

func _on_quit_button_pressed() -> void:
	get_tree().quit()
