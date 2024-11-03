extends Node

#@onready var pause_menu = $Pause
var paused = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_pressed("Pause"):
		get_tree().quit()
		#if paused:
			#get_tree().paused = false
			#pause_menu.hide()
		#else:
			#get_tree().paused = true
			#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			#pause_menu.show()
		
		paused = !paused
