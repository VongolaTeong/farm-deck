extends Area2D

@onready var crop1 = $Crop1TileMapLayer
@onready var crop2 = $Crop2TileMapLayer
@onready var crop3 = $Crop3TileMapLayer
@onready var crop4 = $Crop4TileMapLayer

@onready var growth_stages: Array[TileMapLayer] = [
	crop1,
	crop2,
	crop3,
	crop4
]

# key = Vector2i position, value = growth stage int
var tile_growth: Dictionary = {}

func _ready() -> void:
	# Connect the input_event signal from this Area2D to our handling function
	input_event.connect(_on_input_event)
	hide_crops()

	for tilemap in growth_stages:
		tilemap.visible = true

# This function is called when an input event occurs within the Area2D's shape.
func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	# Check for a left mouse button click
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		var global_pos = event.position
		var local_pos = growth_stages[0].to_local(global_pos)
		var tile_pos = growth_stages[0].local_to_map(local_pos)
		advance_tile_growth(tile_pos)

func hide_crops() -> void:
	for tilemap in growth_stages:
		tilemap.clear()
	
func advance_tile_growth(tile_pos: Vector2i) -> void:
	var stage = tile_growth.get(tile_pos, 0)
	if stage == growth_stages.size() - 1:
		print("Tile", tile_pos, "is fully grown")
		return

	# Remove tile from current stage
	if growth_stages[stage].get_cell_tile_data(tile_pos):
		growth_stages[stage].erase_cell(tile_pos)

	# Advance to next stage
	stage += 1
	tile_growth[tile_pos] = stage
	growth_stages[stage].set_cell(tile_pos, 0, Vector2i(stage, 0))  # Assumes tile index 0 is your crop tile
