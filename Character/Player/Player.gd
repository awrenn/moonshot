extends "res://Character/Character.gd"

const STRENGTH = 50

export (int) var speed = 250
export (int) var jump_speed = -600
export (float, 0, 1.0) var friction = 0.1
export (float, 0, 1.0) var acceleration = 0.5
export (bool) var attacking = false

var velocity = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	anim_state = $Position2D/Body/AnimationTree.get("parameters/playback")
	healthbar = $HealthDisplay

func get_input():
	var right = Input.is_action_pressed("ui_right")
	var left = Input.is_action_pressed("ui_left")
	var attack = Input.is_key_pressed(KEY_SPACE)

	var dir = 0
	if right:
		dir += 1
	if left:
		dir -= 1
	if dir != 0:
		velocity.x = lerp(velocity.x, dir * speed, acceleration)
		anim_state.travel("walk")
	else:
		velocity.x = lerp(velocity.x, 0, friction)
		if anim_state.get_current_node() == "walk":
			anim_state.travel("idle")
			
	if attack && not attacking:
		#attacking = true
		anim_state.travel("attack")

func _physics_process(delta):
	get_input()
		
	if velocity.x < 0:
		$Position2D/Body.scale.x = -1
	if velocity.x > 0:
		$Position2D/Body.scale.x = 1
		
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if is_on_floor():
		friction = 0.1
	else:
		friction = 0.01
	
	if Input.is_action_just_pressed("ui_up"):
		if is_on_floor():
			velocity.y = jump_speed
			anim_state.travel("idle")

func _on_SwordBox_body_entered(body):
	if !body.is_in_group("enemy"):
		return
	body.take_damage(STRENGTH)
