extends Node2D

class_name CubeInstance

var top_points: Array = []
var left_points: Array = []
var right_points: Array = []
var top_face_color: Color
var left_face_color: Color
var right_face_color: Color
var outline_color: Color
var outline_width: float
var initialized: bool = false

# Initialize all properties at once before adding to scene
func init(top: Array, left: Array, right: Array, 
		  top_color: Color, left_color: Color, right_color: Color,
		  o_color: Color, o_width: float):
	
	top_points = top
	left_points = left
	right_points = right
	top_face_color = top_color
	left_face_color = left_color
	right_face_color = right_color
	outline_color = o_color
	outline_width = o_width
	initialized = true
	
	# Force redraw now that we have all data
	queue_redraw()

func _draw():
	# Only draw if properly initialized
	if not initialized:
		return
		
	# Draw the three visible faces of the cube
	
	# Left face (drawn first - furthest back)
	draw_colored_polygon(left_points, left_face_color)
	draw_polyline(left_points + [left_points[0]], outline_color, outline_width)
	
	# Right face (drawn second - middle)
	draw_colored_polygon(right_points, right_face_color)
	draw_polyline(right_points + [right_points[0]], outline_color, outline_width)
	
	# Top face (drawn last - closest to viewer)
	draw_colored_polygon(top_points, top_face_color)
	draw_polyline(top_points + [top_points[0]], outline_color, outline_width)
	
