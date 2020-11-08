extends "res://Character/Enemy/Enemy.gd"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

enum states {PATROL, FLEEING, ATTACK, DEAD}
var curState = states.PATROL

## When patrolling starts,
## mark the current position, and move back and forth between PatrolStart and PatrolStart + PATROL_LENGTH
var patrolStart 
var patrolDir = Vector2(1,0)
const PATROL_LENGTH = 200
const PATROL_SPEED = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	patrolStart = position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if curState == states.PATROL:
		patrol(delta)
		
func patrol(delta):
	if position.x < patrolStart.x or position.x > patrolStart.x + PATROL_LENGTH:
		patrolDir.x *= -1
		$Position2D/Body.flip_h = patrolDir.x == -1
	position.x += patrolDir.x * delta * PATROL_SPEED
