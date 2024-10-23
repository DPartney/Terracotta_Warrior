extends CharacterBody2D

@export var animating := false;
@onready var AP := $AnimationPlayer

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	#print(animating)
	CycleAnimations()
	move_and_slide()

func CycleAnimations():
	if (animating):
		return

	var chosen = randi_range(0, 6)
	match(chosen):
		0:
			AP.play("golem_idle")
		1:
			AP.play("golem_glowing")
		2:
			AP.play("golem_melee")
		3:
			AP.play("golem_ranged")
		4:
			AP.play("golem_laser")
		5:
			AP.play("golem_buff")
		6:
			AP.play("golem_death")
	animating = true

func AnimationFinished(_anim_name: StringName) -> void:
	animating = false
	
