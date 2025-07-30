extends Area2D

@onready var crop1 = $Crop1TileMapLayer

# key = Vector2i position, value = growth stage int
var tile_growth: Dictionary = {}

func _ready() -> void:
	# Connect the input_event signal from this Area2D to our handling function
	input_event.connect(_on_input_event)
	hide_crops()

# This function is called when an input event occurs within the Area2D's shape.
func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	# Check for a left mouse button click
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		var global_pos = event.position
		var local_pos = crop1.to_local(global_pos)
		var tile_pos = crop1.local_to_map(local_pos)
		advance_tile_growth(tile_pos)

func hide_crops() -> void:
	crop1.clear()
	
func advance_tile_growth(tile_pos: Vector2i) -> void:
	var stage = tile_growth.get(tile_pos, 0)
	if stage == 4:
		print("Tile", tile_pos, "is fully grown")
		return

	# Remove tile from current stage
	crop1.erase_cell(tile_pos)

	# Advance to next stage
	stage += 1
	tile_growth[tile_pos] = stage
	crop1.set_cell(tile_pos, 0, Vector2i(stage, 0))  # Assumes tile index 0 is your crop tile
