extends KinematicBody2D


export var alpha = PI  # How fast the player will move (rads/sec).
var screen_size  # Size of the game window.
var theta = 0.0 # Degrees rotation - 0 is top middle
var r = 50 # Distance from center 
var floor_r = 50
var center_x = 50.0
var center_y = 50.0

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2()  # The player's movement vector.
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
		
	if velocity.length() > 0:
		$Pivot/Body.animation = "walk"
	else:
		$Pivot/Body.animation = "idle"
		

	theta += alpha * delta * velocity.x
	r += alpha * delta * velocity.y
	r = clamp(r, floor_r, r)
	position.x = center_x + r * cos(theta)
	position.y = center_y + r * sin(theta)
	
	$Pivot/Body.flip_v = false
	$Pivot/Body.flip_h = velocity.x < 0
