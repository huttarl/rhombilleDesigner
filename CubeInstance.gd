extends Area2D

class_name CubeInstance

var top_points: Array = []
var left_points: Array = []
var right_points: Array = []
var top_face_color: Color
var left_face_color: Color
var right_face_color: Color
var outline_color: Color
var outline_width: float
var cube_size: float
var is_convex: bool = true
var initialized: bool = false

# Initialize all properties at once before adding to scene
func init(size: float, top_color: Color, left_color: Color, right_color: Color,
		  o_color: Color, o_width: float):
	
	cube_size = size
	top_face_color = top_color
	left_face_color = left_color
	right_face_color = right_color
	outline_color = o_color
	outline_width = o_width
	
	# Calculate the points based on the initial state (convex)
	var points = calculate_cube_points(cube_size, is_convex)
	top_points = points.top
	left_points = points.left
	right_points = points.right
	
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

func _input_event(_viewport, event, _shape_idx):
	# This function is called when input occurs within the cube's area
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		toggle_state()

func toggle_state():
	# Toggle between convex and concave
	is_convex = not is_convex
	
	# Recalculate points based on new state
	var points = calculate_cube_points(cube_size, is_convex)
	
	# Update the points
	top_points = points.top
	left_points = points.left
	right_points = points.right
	
	# Request a redraw to show the changes
	queue_redraw()

func calculate_cube_points(size: float, convex: bool):
	# Calculate the points for the three visible faces of the cube
	var half_size = size / 2
	var points = {}
	
	if convex:
		# Standard convex cube
		points.top = [
			Vector2(0, -size),              # Top
			Vector2(size, -half_size),      # Right
			Vector2(0, 0),                  # Bottom
			Vector2(-size, -half_size)      # Left
		]
		
		points.left = [
			Vector2(-size, -half_size),     # Top-left
			Vector2(0, 0),                  # Top-right
			Vector2(0, size),               # Bottom-right
			Vector2(-size, half_size)       # Bottom-left
		]
		
		points.right = [
			Vector2(0, 0),                  # Top-left
			Vector2(size, -half_size),      # Top-right
			Vector2(size, half_size),       # Bottom-right
			Vector2(0, size)                # Bottom-left
		]
	else:
		# Concave cube (inverted vertically)
		points.top = [
			Vector2(0, size),              # Bottom (now top)
			Vector2(size, half_size),      # Right
			Vector2(0, 0),                 # Top (now bottom)
			Vector2(-size, half_size)      # Left
		]
		
		points.left = [
			Vector2(-size, half_size),     # Bottom-left (now top-left)
			Vector2(0, 0),                 # Bottom-right (now top-right)
			Vector2(0, -size),             # Top-right (now bottom-right)
			Vector2(-size, -half_size)     # Top-left (now bottom-left)
		]
		
		points.right = [
			Vector2(0, 0),                 # Bottom-left (now top-left)
			Vector2(size, half_size),      # Bottom-right (now top-right)
			Vector2(size, -half_size),     # Top-right (now bottom-right)
			Vector2(0, -size)              # Top-left (now bottom-left)
		]
	
	return points
