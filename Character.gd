extends KinematicBody2D


export var ALPHA = PI 
export var JUMP_SPEED = 300 # How fast the player will move (rads/sec).
export var PLANET_ALPHA = 1/4

## constants or SSA vars
var screen_size  # Size of the game window.
var center_x
var center_y
var FLOOR_R = 200
var JUMP_STRENGTH = 5
var GRAVITY = 30
var THETA_MIN = (5.0/4.0) * PI 
var THETA_MAX = (7.0/4.0) * PI

var velocity = Vector2()
var theta = 3/2 * PI # Degrees rotation - 0 is top middle
var r = 200 # Distance from center 

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	center_x = screen_size.x / 2
	center_y = screen_size.y / 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var acc = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x = 1
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -1
	else:
		velocity.x = 0
		
	if Input.is_action_pressed("ui_up") && velocity.y == 0:
		velocity.y = JUMP_STRENGTH
	else:
		acc.y -= GRAVITY
	theta -= PLANET_ALPHA * delta
	theta = float_clamp(theta)

	if velocity.x != 0:
		$Pivot/Body.animation = "walk"
	else:
		$Pivot/Body.animation = "idle"
		
	velocity.y += acc.y * delta
	theta += ALPHA * delta * velocity.x
	r += JUMP_SPEED * delta * velocity.y
	if r < FLOOR_R:
		r = FLOOR_R
		velocity.y = 0
		
	position.x = center_x + (r * cos(theta))
	position.y = center_y + (r * sin(theta))
	
	$Pivot/Body.flip_v = false
	$Pivot/Body.flip_h = velocity.x < 0

func float_clamp(theta):
	while theta > 2 * PI:
		theta -= 2 * PI
	while theta < 0:
		theta += 2 * PI
	if theta < THETA_MIN:
		theta = THETA_MIN
	if theta > THETA_MAX:
		theta = THETA_MAX
	return theta
