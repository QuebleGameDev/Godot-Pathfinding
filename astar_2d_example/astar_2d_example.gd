extends Node2D

## A reference to the node that holds all the AStar points.
## NOTE: Points can be added completely through code, we're simply-
## referencing a custom "astar point" class for ease of use.
@export var astar_points_container : Node2D

## A reference to the navigator object that we will move through this script.
@onready var navigator = $Navigator

## Create a new AStar2D object.
var astar = AStar2D.new()
## A list of all the AStar points in our current path.
var path = []

func _input(_event) -> void:
	if Input.is_action_just_pressed("recalculate_path"):
		recalculate_path(get_global_mouse_position())

func _ready():
	if astar_points_container:
		var all_points = astar_points_container.get_children()

		# Add all the AStar points to the AStar2D object.
		for point in all_points:
			astar.add_point(point.get_index(), point.position)

		# Connect all the AStar points to each other.
		for point in all_points:
			for connection in point.connections:
				astar.connect_points(point.get_index(), connection.get_index())

		# Print for visualization (optional)
		for i in astar.get_point_count():
			print(i, " is connected to ", astar.get_point_connections(i))

func _process(delta: float) -> void:
	if path.size() > 0: # If we have a path to follow
		var velocity = navigator.position.direction_to(path[0]) * 200 * delta
		navigator.position += velocity
		if navigator.position.distance_to(path[0]) < 10.0:
			path.remove_at(0)
			print("Current path: ", path)

## Recalculate the path to the target position based on the astar points.
func recalculate_path(target_position: Vector2) -> void:
	path.clear()
	path = astar.get_point_path(astar.get_closest_point(navigator.position), astar.get_closest_point(target_position))
