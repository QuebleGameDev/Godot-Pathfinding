extends Node2D

const WALL_TILE_COORD = Vector2i(0, 0)
const FLOOR_TILE_COORD = Vector2i(1, 0)
const TILE_SIZE = 32

@export var node_one : VisualNode
@export var node_two : VisualNode

@onready var tilemap_layer = $TileMapLayer
@onready var debug_line : Line2D = $DebugLine2D

var astar_grid = AStarGrid2D.new()
var path = []

func _ready() -> void:
	$CanvasLayer/Control/VBoxContainer/RandomizePointsButton.pressed.connect(randomize_point_positions)

	# Set up parameters, then update the grid.
	astar_grid.region = tilemap_layer.get_used_rect()
	astar_grid.cell_size = Vector2(TILE_SIZE, TILE_SIZE)
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.update()

	for tile in tilemap_layer.get_used_cells_by_id(0, WALL_TILE_COORD):
		astar_grid.set_point_solid(tile, true)

	randomize_point_positions()

## Randomize the positoins of the nodes on the grid.
func randomize_point_positions() -> void:
	var floor_tiles = tilemap_layer.get_used_cells_by_id(0, FLOOR_TILE_COORD)
	node_one.position = floor_tiles.pick_random() * TILE_SIZE
	node_two.position = floor_tiles.pick_random() * TILE_SIZE

	recalculate_path()

## Recalculates the path between the two target nodes.
func recalculate_path() -> void:
	path = astar_grid.get_point_path(node_one.position / TILE_SIZE, node_two.position / TILE_SIZE)
	debug_line.points = path
