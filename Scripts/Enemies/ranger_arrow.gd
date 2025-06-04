extends Sprite2D

func _ready() -> void:
	await get_tree().create_timer(3).timeout
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x -= 175 * delta

func _on_area_2d_area_entered(_area: Area2D) -> void:
	queue_free()
