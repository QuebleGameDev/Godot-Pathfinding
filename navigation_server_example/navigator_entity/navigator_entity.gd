extends CharacterBody2D

## The movement speed of the entity
@export var movement_speed: float = 8000.0
## The target node to move to
@export var movement_target: Node2D

## Reference to the navigation agent node.
## A NavigationAgent2D node must be added to your scene and referenced here in order-
## to communicate with the navigation server.
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
## Reference to the recalculation timer.
@onready var recalc_timer : Timer = $RecalcTimer

var on_nav_link : bool = false
var nav_link_end_position : Vector2

func _ready():
	# Connect signals
	recalc_timer.timeout.connect(_on_recalc_timer_timeout)
	navigation_agent.link_reached.connect(_on_navigation_link_reached)
	navigation_agent.waypoint_reached.connect(_on_waypoint_reached)
	navigation_agent.velocity_computed.connect(_on_velocity_computed)

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
	var new_velocity = current_agent_position.direction_to(next_path_position) * movement_speed * delta
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)

## Setup the navigation agent.
func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame
	set_target_position(movement_target.position)

## Set the target position of the navigation agent.
func set_target_position(target_position : Vector2 = Vector2.ZERO) -> void:
	navigation_agent.target_position = target_position

## Called when the recalculation timer times out.
func _on_recalc_timer_timeout() -> void:
	if not on_nav_link:
		set_target_position(movement_target.position)

## Called when a navigation link has been reached.
func _on_navigation_link_reached(details : Dictionary) -> void:
	on_nav_link = true # Temporarily disable recalculation to prevent jittering.
	nav_link_end_position = details.link_exit_position

## Called when a waypoint has been reached.
func _on_waypoint_reached(details : Dictionary) -> void:
	# This next line checks the distance to the waypoint with a threshhold.
	# If the distance is less than 5.0, then the waypoint has been reached.
	# This check produces unexpected results when comparing vectors directly.
	if details.position.distance_to(nav_link_end_position) < 5.0:
		on_nav_link = false

## Called when the navigation agent reports a new velocity.
func _on_velocity_computed(safe_velocity: Vector2):
	velocity = safe_velocity
	move_and_slide()