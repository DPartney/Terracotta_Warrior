extends Area2D

@export var TP_Point : Marker2D
@onready var Fade := $"../../../Overlays/ColorRect"

func _on_area_entered(_area: Area2D) -> void:
	FadeToBlack()
	await get_tree().create_timer(.2).timeout
	Fade.hide()
	PlayerVariables.CurrentPlayer.global_position = TP_Point.global_position
	await get_tree().create_timer(.2).timeout
	get_tree().call_group("Player", "take_damage", 1)
	
func FadeToBlack():
	var screen_size
	screen_size = get_viewport_rect().size
	Fade.size = screen_size
	Fade.show()
	var tween: Tween = create_tween()
	tween.tween_property(Fade, "modulate:a", 1, .15).from(0.0)
	tween.tween_property(Fade, "modulate:a", 0, 1).from(1.0)
	
