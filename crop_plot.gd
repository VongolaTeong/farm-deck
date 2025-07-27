# crop_plot.gd
extends Area2D

# This script assumes its children are the TileMap layers in the correct growth order.

var growth_stages = []
var current_stage: int = 0

func _ready() -> void:
	# Get all child nodes that are TileMap layers
	for child in get_children():
		if child is TileMapLayer:
			growth_stages.append(child)
	
	# Connect the input_event signal from this Area2D to our handling function
	input_event.connect(_on_input_event)
	
	print("current state", current_stage)
	# Set the initial visual state
	update_visuals()

# This function is called when an input event occurs within the Area2D's shape.
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	# Check for a left mouse button click
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		advance_growth()

# Advances the crop to the next stage.
func advance_growth() -> void:
	# Only advance if not already at the final stage
	if current_stage < growth_stages.size() - 1:
		current_stage += 1
		update_visuals()

	else:
		print("Crop is fully grown!")

# Hides all stages and shows only the current one.
func update_visuals() -> void:
	for i in range(growth_stages.size()):
		var stage_node = growth_stages[i]
		if i == current_stage:
			stage_node.visible = true
		else:
			stage_node.visible = false
