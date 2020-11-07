extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	init({})
	pass # Replace with function body.

func init(config):
	var length = get_or(config, "length", 100.0)
	var height = get_or(config, "height", 200)
	var texture = get_or(config, "texture", "res://Zassets/Levels/Mossy/MediumPlatform1.png")
	var moving = get_or(config, "moving", false)
	$CollisionPolygon2D.polygon = PoolVector2Array([[0.0], [length, 0], [length, height], [0, height]])
	$Sprite.texture = load(texture)
	$Sprite.scale = Vector2(length / float($Sprite.texture.get_width()), height / float($Sprite.texture.get_height()))
	print($Sprite.texture.get_width())
	print(length)
	print($Sprite.scale)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func get_or(dict, key, default):
	if !dict.has(key):
		return default
	return dict[key]
