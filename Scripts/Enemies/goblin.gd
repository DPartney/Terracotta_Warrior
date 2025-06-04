extends CharacterBody2D

@onready var AP = $AnimationPlayer
@export var animating := false
var dead := false

func _physics_process(delta: float) -> void:
	if dead:
		return
		
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if ($Hitbox/RayCast2D.is_colliding()):
		velocity = Vector2.ZERO
		AP.play("goblin_attack")
	
	update_animations()
	
	if ($FlipCheck.is_colliding()):
		scale.x = -1
	
	velocity.x = 100 * scale.x
	move_and_slide()

func update_animations():
	if dead || animating: return
	
	if ($DetectPlayer.is_colliding()):
		velocity.x = 150
	else:
		patrol()
	
	if (!velocity):
		AP.play("goblin_idle")
	else:
		AP.play("goblin_run")
	

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "goblin_death":
		queue_free()
	else:
		animating = false

func _on_hurtbox_area_entered(_area: Area2D) -> void:
	$HealthComponent.damage(1)
	if ($HealthComponent.health <= 0):
		dead = true
		AP.play("goblin_death")
	else:
		AP.play("goblin_hurt")
	
func patrol():
	await get_tree().create_timer(randi_range(3, 5)).timeout
	if (randi() % 5):
		velocity.x = 100
	else:
		velocity.x = 0
