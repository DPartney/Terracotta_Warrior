extends CharacterBody2D

@export var animating := false
@export var attacking := false
@onready var AP := $AnimationPlayer
@onready var Position := $Marker2D
@onready var RCLeft := $RayCastLeft
@onready var RCRight := $RayCastRight
@onready var RCDetectPlayer := $Marker2D/DetectPlayer
@onready var HBMelee := $Marker2D/HitboxComponent/MeleeHitbox
@onready var HealthComp := $HealthComponent

const SPEED = 100.0
const JUMP_VELOCITY = -400.0
var Direction := 1
var dead := false

func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_DISABLED

func _physics_process(delta: float) -> void:
	if dead:
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Direction
	if (RCLeft.is_colliding()):
		Direction = 1
		Position.scale.x = 1
	elif  (RCRight.is_colliding()):
		Direction = -1
		Position.scale.x = -1
	
	velocity.x = Direction * SPEED
	
	# Animations
	attack()
	
	update_animations()
	if (!attacking && !animating):
		move_and_slide()

func update_animations():
	if animating || dead:
		return
	attack()
	if (!attacking):
		AP.play("cw_walk")

func attack():
	if (RCDetectPlayer.is_colliding() && !dead):
		attacking = true
		AP.play("cw_attack")

func _on_hurtbox_area_entered(_area: Area2D) -> void:
	HealthComp.damage(1)
	animating = true
	$AudioGrunt.play()
	if HealthComp.health <= 0:
		dead = true
		AP.play("cw_death")
	else:
		AP.play("cw_hurt")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "cw_death":
		queue_free()
	else:
		attacking = false
		animating = false

func PlaySlashSound():
	$AudioSlash.play(2.55)


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	self.process_mode = Node.PROCESS_MODE_PAUSABLE
	#self.visible = true

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	self.process_mode = Node.PROCESS_MODE_DISABLED
	#self.visible = false
