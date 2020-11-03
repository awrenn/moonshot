extends StaticBody2D

var center

# Called when the node enters the scene tree for the first time.
func _ready():
	position = Vector2(0,0)
	center = Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y / 2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _draw():
	print(center)
	draw_circle_arc(center, 400, 0, 2 * PI, 32)

func draw_circle_arc(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var colors = PoolColorArray([color])
	var points_arc = PoolVector2Array()

	for i in range(nb_points + 1):
		var angle_point = angle_from + i * (angle_to-angle_from) / nb_points
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	draw_polygon(points_arc, colors)

