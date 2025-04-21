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
@export var grid_width: int = 5
@export var grid_height: int = 5

# Calculated points for drawing
var top_points: Array = []
var left_points: Array = []
var right_points: Array = []

func _ready():
	# Calculate the points for cube faces
	calculate_cube_points()
	
	# Create a grid of cubes
	for x in range(grid_width):
		for y in range(grid_height):
			# We'll stagger the cubes to create a proper isometric grid
			var pos_x = x * cube_size * 1.5
			var pos_y = y * cube_size * 0.75
			
			# Offset every second row
			if y % 2 == 1:
				pos_x += cube_size * 0.75
			
			draw_cube(Vector2(pos_x, pos_y))

func calculate_cube_points():
	# Calculate the points for the three visible faces of the cube
	# We're using an isometric projection with a 2:1 ratio
	var half_size = cube_size / 2
	
	# Top face (rhombus)
	top_points = [
		Vector2(0, -half_size),              # Top
		Vector2(half_size, 0),               # Right
		Vector2(0, half_size),               # Bottom
		Vector2(-half_size, 0)               # Left
	]
	
	# Left face (rhombus)
	left_points = [
		Vector2(-half_size, 0),              # Top-left
		Vector2(0, half_size),               # Top-right
		Vector2(-half_size, cube_size),      # Bottom-right
		Vector2(-cube_size, half_size)       # Bottom-left
	]
	
	# Right face (rhombus)
	right_points = [
		Vector2(half_size, 0),               # Top-left
		Vector2(cube_size, half_size),       # Top-right
		Vector2(half_size, cube_size),       # Bottom-right
		Vector2(0, half_size)                # Bottom-left
	]

func draw_cube(position: Vector2):
	# Create the cube at the specified position
	var cube = preload("res://CubeInstance.gd").new()
	cube.position = position
	cube.top_points = top_points
	cube.left_points = left_points
	cube.right_points = right_points
	cube.top_face_color = top_face_color
	cube.left_face_color = left_face_color
	cube.right_face_color = right_face_color
	cube.outline_color = outline_color
	cube.outline_width = outline_width
	add_child(cube)
