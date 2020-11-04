extends "res://Character/Character.gd"

export (int) var speed = 40
export (int) var jump_speed = -18
export (int) var gravity = 40

var velocity = Vector2.ZERO

export (float, 0, 1.0) var friction = 0.1
export (float, 0, 1.0) var acceleration = 0.25

var anim_state

# Called when the node enters the scene tree for the first time.
func _ready():
	anim_state = $Position2D/Body/AnimationTree.get("parameters/playback")

func get_input():
	var dir = 0
	if Input.is_action_pressed("ui_right"):
		dir += 1
	if Input.is_action_pressed("ui_left"):
		dir -= 1
	if dir != 0:
		velocity.x = lerp(velocity.x, dir * speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, dir * speed, acceleration)

func _physics_process(delta):
	get_input()
	
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if velocity.length() > 0:
		anim_state.travel("walk")
		
	print(velocity, anim_state.get_current_node())
	if anim_state.get_current_node() == "walk" and velocity.length() == 0:
		anim_state.travel("idle")
	
	if Input.is_action_just_pressed("ui_up"):
		if is_on_floor():
			velocity.y = jump_speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
