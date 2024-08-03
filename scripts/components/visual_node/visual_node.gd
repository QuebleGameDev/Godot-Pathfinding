@tool
extends Node2D
## A visual representation of a point in space.
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
# -----------------------------------------------------------------------------

# FUNCTIONS
# -----------------------------------------------------------------------------
## Set the color of the visualnode.
func _set_color(new_value: int) -> void:
	color = new_value
	if sprite:
		sprite.modulate = COLORS[color]
# -----------------------------------------------------------------------------