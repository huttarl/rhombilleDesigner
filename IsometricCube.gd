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

func _ready():
	# Create a grid of cubes
	for x in range(grid_width):
		for y in range(grid_height):
			# We'll stagger the cubes to create a proper isometric grid
			var pos_x = x * cube_size * 2
			var pos_y = y * cube_size * 1.5
			
			draw_cube(Vector2(pos_x, pos_y))

func draw_cube(position: Vector2):
	# Create the cube at the specified position
	var cube = preload("res://CubeInstance.gd").new()
	
	# Make the cube clickable by adding a collision shape
	setup_cube_collision(cube)
	
	# Set position
	cube.position = position
	
	# Let the cube instance handle its own points calculation
	# by passing necessary parameters
	cube.init(
		cube_size,
		top_face_color,
		left_face_color, 
		right_face_color,
		outline_color,
		outline_width
	)
	
	add_child(cube)

func setup_cube_collision(cube):
	# Make the cube clickable by adding Area2D functionality
	cube.set_script(load("res://CubeInstance.gd"))
	
	# Set as clickable
	cube.input_pickable = true
	
	# Create a collision shape for the cube (approximate with a circle for simplicity)
	var collision = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.radius = cube_size * 0.75  # Large enough to cover the cube
	collision.shape = shape
	cube.add_child(collision)
