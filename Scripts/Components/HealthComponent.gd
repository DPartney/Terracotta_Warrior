extends Node2D
class_name HealthComponent

@export var MAX_HEALTH := 10
var health : float

func _ready():
	health = MAX_HEALTH

func damage(attack):
	health -= attack
	
	if health <= 0:
		get_parent().queue_free()

func heal(heal_amount):
	health += heal_amount
	
	if health >= MAX_HEALTH:
		health = MAX_HEALTH
