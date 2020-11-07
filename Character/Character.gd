extends KinematicBody2D

export (int) var gravity = 2000

# Health
var max_health = 100
var health = max_health
var healthbar = null

# Shadow
onready var floor_finder = $Position2D/FloorFinder
onready var shadow = $Position2D/FloorFinder/Shadow

func _ready():
	floor_finder.cast_to.y = 1000
	pass

func _physics_process(_delta):
	if floor_finder.is_colliding():
		shadow.visible = true
		shadow.position = to_local(floor_finder.get_collision_point())
		shadow.position.y -= shadow.get_rect().size.y / 3
	else:
		shadow.visible = false

func take_damage(value):
	health = clamp(health - value, 0, max_health)
	if healthbar:
		healthbar.update_health(health)
