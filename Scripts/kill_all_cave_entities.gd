extends Area2D

func _on_area_entered(_area: Area2D) -> void:
	var Enemies = get_tree().get_nodes_in_group("CaveEnemies")
	for node in Enemies:
		node.queue_free()
