extends CharacterBody2D

@export var animating := false;
@onready var AP := $AnimationPlayer

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	CycleAnimations()
	move_and_slide()

func CycleAnimations():
	if (animating):
		return

	var chosen = randi_range(0, 2)
	match(chosen):
		0:
			AP.play("executioner_float")
		1:
			AP.play("executioner_attack")
		2:
			AP.play("executioner_death")
	animating = true

func AnimationFinished(_anim_name: StringName) -> void:
	animating = false
