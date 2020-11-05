extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const SPEED = 20
const OVERLAP = 10

var textureWidth


# Called when the node enters the scene tree for the first time.
func _ready():
	var viewportWidth = get_viewport().size.x
	var viewportHeight = get_viewport().size.y

	var x_scale = viewportWidth / $bg.texture.get_size().x
	var y_scale = viewportHeight / $bg.texture.get_size().y
	var scale = max(x_scale, y_scale)
	$bg.set_scale(Vector2(scale, scale))
	$bg2.set_scale(Vector2(scale, scale))
	textureWidth = float($bg.texture.get_size().x) * scale
	
	## Create a perfect backup of this node
	## as the background moves right, have this node follow in perfect sync
	$bg2.flip_h = true
	$bg2.position.x = -textureWidth + OVERLAP
	$bg.set_z_index(-100)
	$bg2.set_z_index(-100)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$bg.position.x += SPEED * delta
	$bg2.position.x += SPEED * delta
	
	if $bg.position.x > textureWidth:
		$bg.position.x = -textureWidth + OVERLAP
	if $bg2.position.x > textureWidth:
		$bg2.position.x = -textureWidth + OVERLAP
		
		
func init_bg_image(node, init_x):
	node.set_z_index(-100)
	node.position.x = init_x

