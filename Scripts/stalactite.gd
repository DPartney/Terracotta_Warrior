extends CharacterBody2D

@export var Area : Area2D

var activated := false

func _physics_process(delta: float) -> void:
	if Area.has_overlapping_bodies():
		activated = true
	
	# Add the gravity.
	if not is_on_floor() && activated:
		velocity += get_gravity() * delta
		move_and_slide()
	
	if is_on_floor():
		queue_free()
	

func area_entered():
	activated = true
