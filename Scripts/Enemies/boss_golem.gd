extends CharacterBody2D

@export var animating := false;
@export var ArmProjectile: PackedScene
@onready var AP := $AnimationPlayer
@onready var RCMelee := $MeleeRaycast
@onready var RCRanged := $RangedRaycast
@onready var ProjectileSpawn := $ArmSpawn

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var dead := false

func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_DISABLED

func _physics_process(delta: float) -> void:
	if dead:
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		move_and_slide()
	
	if (!animating):
		Attack()

func Attack():
	if RCMelee.is_colliding():
		animating = true
		AP.play("golem_melee")
		await get_tree().create_timer(.4).timeout
		$AudioSlash.play()
	elif RCRanged.is_colliding():
		animating = true
		AP.play("golem_ranged")
	else:
		AP.play("golem_idle")

func FireArm():
	var inst = ArmProjectile.instantiate()
	owner.add_child(inst)
	inst.transform = ProjectileSpawn.global_transform

func AnimationFinished(anim_name: StringName) -> void:
	animating = false
	if anim_name == "golem_death":
		queue_free()

func _on_hurtbox_area_entered(_area: Area2D) -> void:
	$HealthComponent.damage(1)
	if $HealthComponent.health  <= 0:
		get_tree().call_group("Player", "EnableExecute")
		dead = true
		$ExecutePrompt.visible = true
		AP.play("golem_glowing")
	elif $HealthComponent.health == $HealthComponent.MAX_HEALTH / 2:
		animating = true
		AP.play("golem_buff")

func Executed():
	await get_tree().create_timer(1.25).timeout
	AP.play("golem_death")
	$AudioDeath.play()

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	self.process_mode = Node.PROCESS_MODE_PAUSABLE
