extends Area2D

func _on_area_entered(area: Area2D) -> void:
	get_tree().call_group("Player", "StartSurf")


func _on_body_entered(body: Node2D) -> void:
	get_tree().call_group("Player", "StartSurf")
