extends Node2D
class_name AStar2DVisualizer

@export() var point_radius = 6
@export() var scale_multiplier = 16
@export() var offset = Vector2(0,0)
@export() var enabled_point_color = Color('00ff00')
@export() var disabled_point_color = Color('ff0000')
@export() var line_color = Color('0000ff')
@export() var line_width = 2

var astar : AStar2D

func visualize(new_astar : AStar2D):
	astar = new_astar

func _point_pos(id):
	return offset + astar.get_point_position(id) * scale_multiplier

func _draw():

	if not astar:
		return

	for point in astar.get_point_ids():
		
		for other in astar.get_point_connections(point):
			draw_line(astar.get_point_position(point), astar.get_point_position(other), line_color, line_width)
			
		var point_color = disabled_point_color if astar.is_point_disabled(point) else enabled_point_color
		draw_circle(astar.get_point_position(point), point_radius, point_color)
