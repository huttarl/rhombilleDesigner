extends Node2D

class_name IsometricCube

# Customizable properties
@export var cube_size: float = 64.0
@export var cube_color: Color = Color(0.2, 0.4, 0.8, 1.0)
@export var top_face_color: Color = Color(0.4, 0.6, 1.0, 1.0)
@export var right_face_color: Color = Color(0.1, 0.3, 0.7, 1.0)
@export var left_face_color: Color = Color(0.3, 0.5, 0.9, 1.0)
@export var outline_color: Color = Color(0.0, 0.0, 0.0, 1.0)
@export var outline_width: float = 2.0
@export var grid_width: int = 6
@export var grid_height: int = 6

func _ready():
	# Create a grid of cubes
	for x in range(grid_width):
		for y in range(grid_height):
			# We'll stagger the cubes to create a proper isometric grid
			var pos_x = (x + 1) * cube_size * 2
			var pos_y = (y + 1) * cube_size * 1.5
			
			# Offset every second row
			if y % 2 == 1:
				pos_x += cube_size * 1.0
			
			draw_cube(Vector2(pos_x, pos_y))

func calculate_cube_points(size: float):
	# Calculate the points for the three visible faces of the cube
	# We're using an isometric projection with a 2:1 ratio
	var half_size = size / 2
	var points = {}
	
	# Top face (rhombus)
	points.top = [
		Vector2(0, -size),              # Top
		Vector2(size, -half_size),               # Right
		Vector2(0, 0),               # Bottom
		Vector2(-size, -half_size)               # Left
	]
	
	# Left face (rhombus)
	points.left = [
		Vector2(-size, -half_size),              # Top-left
		Vector2(0, 0),               # Top-right
		Vector2(0, size),           # Bottom-right
		Vector2(-size, half_size)            # Bottom-left
	]
	
	# Right face (rhombus)
	points.right = [
		Vector2(0, 0),               # Top-left
		Vector2(size, -half_size),            # Top-right
		Vector2(size, half_size),            # Bottom-right
		Vector2(0, size)                # Bottom-left
	]
	
	return points

func draw_cube(position: Vector2):
	# Calculate points for this specific cube
	var points = calculate_cube_points(cube_size)
	
	# Create the cube at the specified position
	var cube = preload("res://CubeInstance.gd").new()
	cube.position = position
	
	# Initialize the cube with all required data before adding to the scene
	cube.init(
		points.top,
		points.left, 
		points.right,
		top_face_color,
		left_face_color, 
		right_face_color,
		outline_color,
		outline_width
	)
	
	add_child(cube)
