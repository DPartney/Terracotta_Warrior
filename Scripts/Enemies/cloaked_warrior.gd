extends CharacterBody2D

@export var animating := false
@export var attacking := false
@onready var AP := $AnimationPlayer
@onready var Position := $Marker2D
@onready var RCLeft := $RayCastLeft
@onready var RCRight := $RayCastRight
@onready var RCDetectPlayer := $Marker2D/DetectPlayer
@onready var HBMelee := $Marker2D/HitboxComponent/MeleeHitbox

const SPEED = 100.0
const JUMP_VELOCITY = -400.0
var Direction := 1


func _physics_process(delta: float) -> void:
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
	if (RCDetectPlayer.is_colliding()):
		AP.play("cw_attack")
		attacking = true
	
	update_animations()
	
	if (!attacking):
		move_and_slide()

func update_animations():
	attack()
	if (!attacking):
		AP.play("cw_walk")

func attack():
	if (RCDetectPlayer.is_colliding()):
		attacking = true
		AP.play("cw_attack")


func _on_hitbox_component_body_entered(body: Node2D) -> void:
	body.owner.has_method("take_damage")
