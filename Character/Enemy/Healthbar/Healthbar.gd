extends Node2D

var healthbar

func _ready():
	healthbar = $HealthBar
	healthbar.max_value = get_parent().max_health

func _process(_delta):
	global_rotation = 0

func update_health(value):
	print(value)
	healthbar.value = value
