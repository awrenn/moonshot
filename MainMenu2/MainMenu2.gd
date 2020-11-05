extends CanvasLayer

export (float) var speed = 25
var nodes = []
var idx = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	$CenterContainer/Camera2D.position.y = get_viewport().size.y / 2
	nodes.append($CenterContainer/Menu/MenuItem/Sprite)
	nodes.append($CenterContainer/Menu/MenuItem2/Sprite)
	nodes.append($CenterContainer/Menu/MenuItem3/Sprite)

func get_input():
	var prev_idx = idx
	if Input.is_action_just_pressed("ui_up"):
		idx -= 1
		
	if Input.is_action_just_pressed("ui_down"):
		idx += 1
		
	idx = clamp(idx, 0, nodes.size() - 1)
	if prev_idx != idx:
		nodes[prev_idx].visible = false
		nodes[idx].visible = true
		
	if Input.is_action_just_pressed("ui_accept"):
		# TODO swith to the new scene
		print("SWITCH SCENES HERE")

func _process(delta):
	get_input()
	$CenterContainer/Camera2D.position.x += speed * delta
