extends "res://Character/Enemy/Enemy.gd"

enum states {PATROL, CHASE, ATTACK, DEAD}
var state = states.PATROL

# For setting animations.
var anim_state
var run_speed = 25
var attacks = ["attack"]
var velocity = Vector2.ZERO

# For path following. TODO

# Target for chase mode
var player = null

# Attack power
var STENGTH = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	anim_state = $Position2D/Body/AnimationTree.get("parameters/playback")

func choose_action():
	velocity = Vector2.ZERO
	var current = anim_state.get_current_node()
	
	if current in attacks:
		return
		
	if !player and state != states.DEAD:
		state = states.PATROL
		
	var target
	match state:
		states.DEAD:
			set_physics_process(false)
			
		states.PATROL:
			return
			
		states.CHASE:
			target = player.position
			velocity = (target - position).normalized() * run_speed
			
		states.ATTACK:
			target = player.position
			if target.x > position.x:
				$Position2D/Body.scale.x = 1
			elif target.x < position.x:
				$Position2D/Body.scale.x = -1
			anim_state.travel("attack")

func _physics_process(delta):
	choose_action()
	
	if velocity.x > 0:
		$Position2D/Body.scale.x = 1
	elif velocity.x < 0:
		$Position2D/Body.scale.x = -1
	
	if velocity.length() > 0:
		anim_state.travel("walk")
	
	if anim_state.get_current_node() == "walk" and velocity.length() == 0:
		anim_state.travel("idle")
	
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity)

func _on_DetectRange_body_entered(body):
	if body.is_in_group("player"):
		state = states.CHASE
		player = body

func _on_DetectRange_body_exited(body):
	if body.is_in_group("player"):
		state = states.PATROL
		player = null

func _on_AttackRange_body_entered(body):
	if body.is_in_group("player"):
		state = states.ATTACK

func _on_AttackRange_body_exited(body):
	if body.is_in_group("player"):
		state = states.CHASE
		anim_state.travel("walk")

func _on_SwordBox_body_entered(body):
	if body.is_in_group("hitbox") and body.is_in_group("player"):
		body.take_damage(STENGTH)
