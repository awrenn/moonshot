extends KinematicBody2D


export var alpha = PI 
export var jump_speed = 300 # How fast the player will move (rads/sec).
var screen_size  # Size of the game window.
var theta = 0.0 # Degrees rotation - 0 is top middle
var r = 200 # Distance from center 
var floor_r = 200
var center_x
var center_y
var velocity = Vector2()

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
		velocity.y = 5
	else:
		acc.y -= 20
		
	if velocity.x != 0:
		$Pivot/Body.animation = "walk"
	else:
		$Pivot/Body.animation = "idle"
		
	velocity.y += acc.y * delta
	theta += alpha * delta * velocity.x
	r += jump_speed * delta * velocity.y
	if r < floor_r:
		r = floor_r
		velocity.y = 0
		
	position.x = center_x + r * cos(theta)
	position.y = center_y + r * sin(theta)
	
	$Pivot/Body.flip_v = false
	$Pivot/Body.flip_h = velocity.x < 0
