extends "res://Character/Enemy/Enemy.gd"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

enum states {PATROL, FLEE, STALK, ATTACK, DEAD}
var curState = states.PATROL
var yPos ## Y should be constant for lifetime - set this at object creation

## When patrolling starts,
## mark the current position, and move back and forth between PatrolStart and PatrolStart + PATROL_LENGTH
var patrolStart 
var moveDir = Vector2(1,0)
const PATROL_LENGTH = 200
const PATROL_SPEED = 100

## Only attack if have at least this many friends nearby
const FRIEND_ATTACK_COUNT = 0
const FRIEND_DISTANCE = 40
const FLEE_DISTANCE = 100
const FLEE_SPEED = 150
var fleePoint = Vector2(0, 0)

const ATTACK_DIP_SPEED = 300
const ATTACK_TIME = 0.7
const STRIKE_DISTANCE = 100
const ATTACK_RETURN_GRAVITY = 10 ## how fast do we return to our original level?
const STRENGTH = 5
var attacks = ["attack1", "attack2", "attack3"]

var animState


# Called when the node enters the scene tree for the first time.
func _ready():
	animState = $Position2D/Body/AnimationTree.get("parameters/playback")
	animState.start("patrol")
	enterPatrol()
	yPos = position.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	checkStateTransition()
	if curState == states.PATROL:
		patrol(delta)
	elif curState == states.FLEE:
		flee(delta)
	elif curState == states.STALK:
		stalk(delta)
	elif curState == states.ATTACK:
		attack(delta)
	$Position2D/Body.flip_h = moveDir.x == -1
		
func patrol(delta):
	if position.x < patrolStart.x or position.x > patrolStart.x + PATROL_LENGTH:
		moveDir.x *= -1
	position.x += moveDir.x * delta * PATROL_SPEED

func checkStateTransition():
	var fc = friendCount()
	if curState == states.STALK and fc < FRIEND_ATTACK_COUNT:
		enterFlee()
	if curState == states.PATROL and fc >= FRIEND_ATTACK_COUNT:
		enterStalk()

func enterPatrol():
	patrolStart = position
	curState = states.PATROL
	animState.travel("patrol")

func enterFlee():
	animState.travel("flee")
	curState = states.FLEE
	fleePoint = position.x + FLEE_DISTANCE * moveDir
	
func flee(delta):
	if position.x * moveDir.x > fleePoint.x * moveDir.x:
		enterPatrol()
	position.x += moveDir.x * delta * FLEE_SPEED
	
func enterStalk():
	curState = states.STALK
	
func stalk(delta):
	animState.travel("stalk")
	var players = get_tree().get_nodes_in_group("player")
	if len(players) == 0:
		return
	var player = players[0]
	## Attack the player if they get within striking distance while we're stalking
	if player.global_position.distance_to(global_position) < STRIKE_DISTANCE:
		enterAttack()
		return
		
	if moveDir.x * (global_position.x - player.global_position.x) > 0:
		moveDir.x *= -1
	position.x += moveDir.x * PATROL_SPEED * delta
	
var attackVelocity = Vector2(0,0)
func enterAttack():
	animState.travel(attacks[randi() % attacks.size()])
	curState = states.ATTACK
	attackVelocity = Vector2(moveDir.x * PATROL_SPEED, ATTACK_DIP_SPEED)
	
func attack(delta):
	position += attackVelocity * delta
	if position.y < yPos:
		position.y = yPos
		enterStalk()
		return
	attackVelocity.y -= ATTACK_RETURN_GRAVITY

	
func friendCount():
	var bats = get_tree().get_nodes_in_group("bats")
	var friends = -1 ## start down for ourself
	for b in bats:
		if b.global_position.distance_to(self.global_position) < FRIEND_DISTANCE:
			friends += 1
	return friends

func doDamage(body):
	body.take_damage(STRENGTH)
	
func _on_ChompBox_body_entered(body):
	if body.is_in_group("hitbox") and body.is_in_group("player"):
		doDamage(body)
		
func _on_SpinBox_body_entered(body):
	if body.is_in_group("hitbox") and body.is_in_group("player"):
		doDamage(body)


func _on_SpookBox_body_entered(body):
	if body.is_in_group("hitbox") and body.is_in_group("player"):
		doDamage(body)
