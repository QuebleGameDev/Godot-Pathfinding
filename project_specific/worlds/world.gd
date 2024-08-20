extends CanvasLayer

func _ready():
	printerr("Scenes are meant to be run independently.\nPlease open the desired pathfinding example scene, then run it independently.")
	for child in get_node("ExampleScenes (run independently)").get_children():
		child.queue_free()