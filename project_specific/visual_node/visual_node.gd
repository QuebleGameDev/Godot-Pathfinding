@tool
extends Node2D
## A visual representation of a point in space.
## Used simply to show the pathfinding algorithms in action.
class_name VisualNode

# CONSTANTS
# -----------------------------------------------------------------------------
const COLORS = {
	0: Color.LIGHT_SKY_BLUE,
	1: Color.INDIAN_RED,
	2: Color.SEA_GREEN,
}
# -----------------------------------------------------------------------------

# EXPORTS
# -----------------------------------------------------------------------------
## The color of the visualnode.
@export_enum("Blue", "Red", "Green") var color: int = 0: set = _set_color
## The sprite of the visualnode.
@export var sprite: Sprite2D = null
## If the visualnode should follow the mouse.
@export var follow_mouse : bool = false
# -----------------------------------------------------------------------------

# FUNCTIONS
# -----------------------------------------------------------------------------
## Set the color of the visualnode.
func _set_color(new_value: int) -> void:
	color = new_value
	if sprite:
		sprite.modulate = COLORS[color]

func _process(_delta):
	if follow_mouse and !Engine.is_editor_hint():
		global_position = get_global_mouse_position()
# -----------------------------------------------------------------------------