extends CharacterBody2D

@onready var AP = $AnimationPlayer
@onready var S2D = $Sprite2D
@onready var CS2D = $CollisionShape2D
@export var attacking := false
@export var dead := false

const SPEED = 250.0
const JUMP_VELOCITY = -450.0

func _physics_process(delta: float) -> void:
	if (dead):
		pass
	var direction = Input.get_axis("Left", "Right")
	
	# Movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = 0

	# Rotation
	if !attacking:
		if (direction == 1):
			S2D.flip_h = false
		elif direction == -1:
			S2D.flip_h = true
			
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# Drop
	if Input.is_action_pressed("Down") and is_on_floor() and !attacking:
		position.y += 2

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
	if (!attacking):
		if velocity.x != 0:
			AP.play("wind_run")
		else:
			AP.play("wind_idle")
	
		if velocity.y < 0:
			AP.play("wind_jump")
		elif velocity.y > 0:
			AP.play("wind_fall")

func take_damage(damage):
	if dead:
		return
	PlayerVariables.PlayerHealth -= damage
	attacking = true
	#knockback()
	AP.play("wind_damaged")
	if (PlayerVariables.PlayerHealth <= 0):
		dead = true
		AP.play("wind_death")
		
func knockback():
	velocity = Vector2(-600, -100 * 2)
	pass

func _on_hurtbox_area_entered(_area: Area2D) -> void:
	take_damage(1)

func _on_hurtbox_body_entered(_body: Node2D) -> void:
	take_damage(1)

func player_died():
	get_tree().quit()
