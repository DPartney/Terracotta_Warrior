extends Node2D

@onready var AP := $AnimationPlayer
@onready var RCBeam := %RCBeam
@onready var RCBramble := %RCBramble
@onready var RCRanged := %RCRanged
@onready var RCMelee := %RCMelee

@export var BasicArrow : PackedScene

var BeamReady := true
var BrambleReady := true
var HitAnimReady := true
var Animating := false
var Dead := false

func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_DISABLED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Dead:
		return
	
	Attack()

func Attack():
	if Animating:
		return
	
	if RCBeam.is_colliding() && BeamReady:
		BeamReady = false
		AP.play("leaf_beam")
		$BeamCD.start()
	elif RCMelee.is_colliding():
		AP.play("leaf_melee_attack")
	elif RCRanged.is_colliding():
		AP.play("leaf_ranged_attack")
	else:
		AP.play("leaf_idle")
		
	#if RCBramble.is_colliding() && BrambleReady:
		#BrambleReady = false
		#AP.play("leaf_bramble")
		#$BrambleCD.start()

func _on_beam_cd_timeout() -> void:
	BeamReady = true

func _on_bramble_cd_timeout() -> void:
	BrambleReady = true

func _on_hit_cd_timeout() -> void:
	HitAnimReady = true

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "leaf_death":
		queue_free()
	else:
		Animating = false

func _on_animation_player_current_animation_changed(_anim_name: String) -> void:
	Animating = true

func _on_hurtbox_area_entered(_area: Area2D) -> void:
	if Dead:
		return
	$HealthComponent.damage(1)
	if $HealthComponent.health <= 0:
		AP.stop()
		Dead = true
		AP.play("leaf_death")
		$Death.play()
	elif HitAnimReady:
		AP.stop()
		HitAnimReady = false
		AP.play("leaf_hit")
		$Hurt.play(0)
		$HitCD.start()

func SpawnBasicArrow():
	var inst = BasicArrow.instantiate()
	owner.add_child(inst)
	inst.transform = $ArrowSpawn.global_transform
	$Arrow.play(.2)

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	self.process_mode = Node.PROCESS_MODE_PAUSABLE
