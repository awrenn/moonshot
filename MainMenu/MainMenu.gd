extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const SELECT_TIMER = .1
var selectTimer = .1

var TEXT_WIDTH
var TEXT_HEIGHT

var selectedIndex = 0
var nodes = []
var selectedChanged = true

var MAIN_MENU = [{
	"text": "New Game",	
	"next": "res://World.tscn",
}, {
	"text": "Leaderboard",
	"next": "res://Leaderboard.tscn",
}]

var ListItemTemplate = preload("res://MainMenu/MainMenuItem.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var vpH = get_viewport().size.y
	var vpW = get_viewport().size.x
	position.x = vpW * 1/3
	position.y = vpH * 1/3
	TEXT_HEIGHT = vpH * 1/20
	TEXT_WIDTH = vpW * 1/2
	
	var heightOffset = 0
	for item in MAIN_MENU:
		heightOffset = init_label(item["text"], heightOffset)
	nodes[0].find_node("ghost").show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var changed = processKeys(delta)
	if changed:
		for i in nodes.size():
			if i == selectedIndex:
				nodes[i].find_node("ghost").show()
			else:
				nodes[i].find_node("ghost").hide()
			

func init_label(text, heightOffset):
	var item = ListItemTemplate.instance()
	item.position.y += heightOffset
	var t = item.find_node("text")
	t.set_size(Vector2(TEXT_WIDTH, TEXT_HEIGHT))
	t.set_text(text)
	add_child(item)
	nodes.append(item)
	return heightOffset + TEXT_HEIGHT
	
func processKeys(delta):
	if selectTimer < SELECT_TIMER:
		selectTimer += delta
		return false
	if Input.is_action_pressed("ui_up"):
		changeSelected(-1)
		return true
	if Input.is_action_pressed("ui_down"):
		changeSelected(1)
		return true
	if Input.is_key_pressed(KEY_SPACE):
		get_tree().change_scene(MAIN_MENU[selectedIndex]["next"])
	return false
		
func changeSelected(dir):
	selectTimer = 0
	selectedIndex = clamp(selectedIndex + dir, 0, MAIN_MENU.size()-1)
