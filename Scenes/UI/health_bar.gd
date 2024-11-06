extends Control

@onready var HealthBar = $TextureProgressBar

func _ready() -> void:
	$".".show()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	match PlayerVariables.PlayerHealth:
		0:
			HealthBar.value = 0
		1:
			HealthBar.value = 1
		2:
			HealthBar.value = 2
		3:
			HealthBar.value = 3
		4:
			HealthBar.value = 4
		5:
			HealthBar.value = 5
		6:
			HealthBar.value = 6
		7:
			HealthBar.value = 7
		8:
			HealthBar.value = 8
