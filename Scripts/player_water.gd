extends CharacterBody2D

@onready var AP = $AnimationPlayer
@onready var S2D = $Water
@onready var Position = $Marker2D
@export var attacking := false
@export var dead := false

const SPEED = 250.0
const JUMP_VELOCITY = -450.0
var wind_player : PackedScene
var surfing := false
var running := false


func _ready() -> void:
	PlayerVariables.CurrentPlayer = $"."
	wind_player = load("res://Scenes/player_wind.tscn")

func _physics_process(delta: float) -> void:
	
	if (dead):
		return
	
	if (Input.is_action_just_pressed("Swap Wind")):
		var camera = get_tree().get_first_node_in_group("Camera")
		var new_player = wind_player.instantiate()
		owner = get_tree().get_first_node_in_group("Main")
		owner.add_child(new_player)
		$".".remove_child(camera)
		new_player.add_child(camera)
		new_player.global_position = $".".global_position
		$".".queue_free()
		
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
			Position.scale.x = 1
		elif direction == -1:
			Position.scale.x = -1
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
		
func update_animation():
	if (!attacking && !surfing):
		if velocity.x != 0:
			AP.play("water_walk")
			if !running:
				running = true
				$AudioRun.play()
		else:
			AP.play("water_idle")
			running = false
			$AudioRun.stop()

		if velocity.y < 0:
			AP.play("water_jump")
			running = false
			$AudioRun.stop()
		elif velocity.y > 0:
			AP.play("water_fall")
			running = false
			$AudioRun.stop()

func attack():
	if Input.is_action_just_pressed("Attack") and is_on_floor() and !attacking:
		attacking = true
		AP.play("water_attack")
		await get_tree().create_timer(.1).timeout
		$AudioSlash.play()

func take_damage(damage):
	if dead || PlayerVariables.Immune:
		return
	PlayerVariables.PlayerHealth -= damage
	PlayerVariables.Immune = true
	
	$Timer.start()
	attacking = true
	if (PlayerVariables.PlayerHealth <= 0):
		dead = true
		$AudioDeath.play(.5)
		AP.play("water_death")
	else:
		$AudioGrunt.play()
		AP.play("water_damaged")

func _on_hurtbox_area_entered(_area: Area2D) -> void:
	take_damage(1)

func _on_hurtbox_body_entered(_body: Node2D) -> void:
	take_damage(1)

func _on_timer_timeout() -> void:
	PlayerVariables.Immune = false

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "water_death":
		get_tree().quit()

func enableRunNoise():
	if !surfing:
		$AudioRun.play()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "Water":
		running = false
		$AudioRun.stop()
		$AudioSurf.play()
		surfing = true
		AP.play("water_surf")

func _on_area_2d_area_exited(_area: Area2D) -> void:
	surfing = false
	$AudioSurf.stop()
