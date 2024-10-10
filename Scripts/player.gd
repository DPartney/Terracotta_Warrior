extends CharacterBody2D

@onready var AP = $AnimationPlayer
@onready var S2D = $Sprite2D
@export var attacking := false

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var in_air := false

func _physics_process(delta: float) -> void:
	
	var direction = Input.get_axis("Left", "Right")
	
	# Movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = 0

	# Rotation
	if (direction == 1):
		S2D.flip_h = false
	elif direction == -1:
		S2D.flip_h = true
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		in_air = true
	else:
		in_air = false

	# Jump
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY	
	
	if Input.is_action_just_released("Jump") and velocity.y < 0:
		velocity.y = JUMP_VELOCITY / 6

	update_animation()
	attack()
	if !attacking:
		move_and_slide()
	
func attack():
	if Input.is_action_just_pressed("Attack") and is_on_floor():
		attacking = true
		AP.play("wind_attack")
		
func update_animation():
	if !attacking:
		if velocity.x != 0:
			AP.play("wind_run")
		else:
			AP.play("wind_idle")
	
		if velocity.y < 0:
			AP.play("wind_jump")
		elif velocity.y > 0:
			AP.play("wind_fall")
