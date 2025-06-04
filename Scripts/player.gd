extends CharacterBody2D
class_name Player_Wind

@onready var AP = $AnimationPlayer
@onready var S2D = $Wind
@onready var Position = $Marker2D
@onready var CS2D = $CollisionShape2D
@export var attacking := false
@export var dead := false

const SPEED = 250.0
const JUMP_VELOCITY = -450.0
var can_execute := false
var water_player : PackedScene
var running := false

func _ready() -> void:
	PlayerVariables.CurrentPlayer = $"."
	water_player = load("res://Scenes/player_water.tscn")

func _physics_process(delta: float) -> void:
	
	if (dead):
		return
	
	if (Input.is_action_just_pressed("Swap Water")):
		if !PlayerVariables.WaterUnlocked:
			return
		var camera = get_tree().get_first_node_in_group("Camera")
		var new_player = water_player.instantiate()
		owner = get_tree().get_first_node_in_group("Main")
		owner.add_child(new_player)
		$".".remove_child(camera)
		new_player.add_child(camera)
		new_player.global_position = $".".global_position
		$".".queue_free()
	
	if Input.is_action_pressed("Execute") && can_execute:
		can_execute = false
		attacking = true
		get_tree().call_group("Golem", "Executed")
		PlayerVariables.Immune = true
		$".".global_position.x = -1516
		$".".global_position.y = 535
		AP.play("wind_execute")
		
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
	
func attack():
	if Input.is_action_just_pressed("Attack") and is_on_floor() and !attacking:
		attacking = true
		$AudioSlash.play()
		AP.play("wind_attack")
		
func update_animation():
	if (!attacking):
		if velocity.x != 0:
			AP.play("wind_run")
			if !running:
				running = true
				$AudioRun.play()
		else:
			AP.play("wind_idle")
			running = false
			$AudioRun.stop()
	
		if velocity.y < 0:
			AP.play("wind_jump")
			running = false
			$AudioRun.stop()
		elif velocity.y > 0:
			AP.play("wind_fall")
			running = false
			$AudioRun.stop()

func take_damage(damage):
	if dead || PlayerVariables.Immune:
		return
	PlayerVariables.PlayerHealth -= damage
	PlayerVariables.Immune = true
	$AudioGrunt.play()
	$Timer.start()
	attacking = true
	if (PlayerVariables.PlayerHealth <= 0):
		dead = true
		AP.play("wind_death")
	else:
		AP.play("wind_damaged")
	
func EnableExecute():
	can_execute = true

func _on_hurtbox_area_entered(_area: Area2D) -> void:
	take_damage(1)

func _on_hurtbox_body_entered(_body: Node2D) -> void:
	take_damage(1)

func player_died():
	get_tree().quit()

func _on_timer_timeout() -> void:
	PlayerVariables.Immune = false

func enableRunNoise():
	$AudioRun.play()
