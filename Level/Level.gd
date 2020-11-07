extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var objectStash = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	self.init([], [{
		"type": "platform",
		"length": 1000,
		"height": 1000,
		"x": 100,
		"y": 100,
	}])
	position = Vector2(100,100)
	pass # Replace with function body.

# init takes in the parameters needed to construct the level
# It will build the level based on a list of input objects
# The caller can pass in boths enemies and objects
func init(enemies, objects):
	for obj in objects:
		var objType = obj["type"]
		if !objectStash.has(objType):
			objectStash[objType] = load("res://Level/Objects/" + objType + ".tscn")
		var instance = objectStash[objType].instance()
		instance.init(obj)
		self.add_child(instance)



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
