extends Sprite2D

func _process(_delta: float) -> void:
	position.x -= 150 * _delta

func _on_area_2d_body_entered(_body: Node2D) -> void:
	queue_free()
