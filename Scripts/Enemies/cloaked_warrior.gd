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

	var chosen = randi_range(0, 5)
	match(chosen):
		0:
			AP.play("cw_idle")
		1:
			AP.play("cw_walk")
		2:
			AP.play("cw_attack")
		3:
			AP.play("cw_ranged")
		4:
			AP.play("cw_hurt")
		5:
			AP.play("cw_death")
	animating = true

func AnimationFinished(_anim_name: StringName) -> void:
	animating = false
