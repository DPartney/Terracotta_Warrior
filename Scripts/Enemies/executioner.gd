extends CharacterBody2D

@export var animating := false;
@onready var AP := $AnimationPlayer

var dead := false

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_DISABLED

func _physics_process(delta: float) -> void:
	if dead:
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		move_and_slide()
	
	UpdateAnimations()

func UpdateAnimations():
	if animating:
		return
	
	if $Marker2D/RayCast2D.is_colliding():
		AP.play("executioner_attack")
		animating = true
	else:
		AP.play("executioner_float")

func AnimationFinished(_anim_name: StringName) -> void:
	animating = false
	if _anim_name == "executioner_death":
		queue_free()


func _on_hurtbox_area_entered(_area: Area2D) -> void:
	$HealthComponent.damage(1)
	if $HealthComponent.health <= 0:
		if dead:
			return
		dead = true
		$AudioStreamPlayer2D.play()
		AP.play("executioner_death")

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	self.process_mode = Node.PROCESS_MODE_PAUSABLE
	#self.visible = true

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	self.process_mode = Node.PROCESS_MODE_DISABLED
	#self.visible = false
