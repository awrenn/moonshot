extends KinematicBody2D

export var SPEED = 300 # How fast the player will move (rads/sec).

var velocity = Vector2.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity.x = 0
	if Input.is_action_pressed("ui_right"):
		velocity.x += SPEED
	elif Input.is_action_pressed("ui_left"):
		velocity.x -= SPEED
	
	if velocity.x != 0:
		$Pivot/Body.animation = "walk"
	else:
		$Pivot/Body.animation = "idle"
		
	$Pivot/Body.flip_h = velocity.x < 0

	move_and_slide(velocity, Vector2.UP)
