extends CharacterBody2D

# EXPORTS
# -----------------------------------------------------------------------------
## The movement speed of the entity
@export var movement_speed: float = 3000.0
## The target node to move to
@export var movement_target: Node2D
# -----------------------------------------------------------------------------

# ONREADY
# -----------------------------------------------------------------------------
## Reference to the navigation agent node.
## A NavigationAgent2D node must be added to your scene and referenced here in order-
## to communicate with the navigation server.
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

## Reference to the recalculation timer.
@onready var recalc_timer : Timer = $RecalcTimer
# -----------------------------------------------------------------------------

# FUNCTIONS
# -----------------------------------------------------------------------------
func _ready():
	# Connect signals
	recalc_timer.timeout.connect(_on_recalc_timer_timeout)
	navigation_agent.link_reached.connect(_on_navigation_link_reached)

	# These values need to be adjusted according to the actor's speed, -
	# the navigation layout, and the actor's collision shape.
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0

	# On the first frame the NavigationServer map has not-
	# yet been synchronized; region data and any path query will return empty.
	# Wait for the NavigationServer synchronization by awaiting one frame in the script.
	# Make sure to not await during _ready.
	call_deferred("actor_setup")

func _physics_process(delta):
	# Returns if we've reached the end of the path.
	if navigation_agent.is_navigation_finished():
		return

	# Get the next path point from the navigation agent.
	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()

	# Calculate the velocity to move towards the next path point.
	velocity = current_agent_position.direction_to(next_path_position) * movement_speed * delta
	move_and_slide()

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame
	recalc_target_position()

func recalc_target_position() -> void:
	if !movement_target: printerr("Movement target not set!"); return # Breaks if movement_target is null
	navigation_agent.target_position = movement_target.global_position

## Called when the recalculation timer times out.
func _on_recalc_timer_timeout() -> void:
	recalc_target_position()

## Called when a navigation link has been reached.
func _on_navigation_link_reached(details : Dictionary) -> void:
	print("Navigation link reached: ", details)
# -----------------------------------------------------------------------------

