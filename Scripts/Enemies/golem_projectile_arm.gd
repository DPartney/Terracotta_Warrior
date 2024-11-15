extends Node2D

@onready var AP := $AnimatedSprite2D
var velocity := 3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AP.play("fire")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	position.x += velocity

func _on_timer_timeout() -> void:
	$".".queue_free()
