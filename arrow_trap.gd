extends Node2D

@export var Arrow : PackedScene

var active := false

func _physics_process(_delta: float) -> void:
	if active:
		$AnimationPlayer.play("shoot")
	else:
		$AnimationPlayer.play("RESET")

func SpawnArrow():
	if !active: return
	
	var inst = Arrow.instantiate()
	owner.add_child(inst)
	inst.transform = $Marker2D.global_transform
	$AudioShoot.play(.2)

func _on_activate_area_area_entered(_area: Area2D) -> void:
	active = true

func _on_activate_area_area_exited(_area: Area2D) -> void:
	active = false
