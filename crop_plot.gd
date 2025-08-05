extends Area2D

@onready var crop = $CropTileMapLayer

# key = Vector2i position, value = growth stage int
var tile_growth: Dictionary = {}
# key = Vector2i position, value = tile type int and crop type int
var tile_type: Dictionary = {}

const TILE_TYPES: Array = [0, 1]

var selected_seed = TILE_TYPES[0]

@onready var corn_count = $"../CornCounter/CornCount"
@onready var melon_count = $"../MelonCounter/MelonCount"

# number of harvested crops
var harvested_crops = [0, 0]

func _ready() -> void:
	# Connect the input_event signal from this Area2D to our handling function
	input_event.connect(_on_input_event)
	hide_crops()

# This function is called when an input event occurs within the Area2D's shape.
func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	# Check for a left mouse button click
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		var global_pos = event.position
		var local_pos = crop.to_local(global_pos)
		var tile_pos = crop.local_to_map(local_pos)
		advance_tile_growth(tile_pos)

func hide_crops() -> void:
	crop.clear()
	
func harvest(tile_pos: Vector2i) -> void:
	crop.erase_cell(tile_pos)
	harvested_crops[selected_seed] += 1
	tile_growth.set(tile_pos, 0)
	
	if (selected_seed == 0):
		corn_count.text = str(harvested_crops[selected_seed])
	else:
		melon_count.text = str(harvested_crops[selected_seed])
	
	print("harvest crop from ", tile_pos, "current total: ", harvested_crops[selected_seed])
	
func advance_tile_growth(tile_pos: Vector2i) -> void:
	var stage = tile_growth.get(tile_pos, 0)
	var type = tile_type.get(tile_pos, selected_seed)
	if stage == 4:
		print("Tile", tile_pos, "is fully grown")
		harvest(tile_pos)
		return
		
	if (type != selected_seed && stage != 0):
		print("crop type doesn't match for", tile_pos, "do not grow")
		return

	# Remove tile from current stage
	crop.erase_cell(tile_pos)

	# Advance to next stage
	stage += 1
	tile_growth[tile_pos] = stage
	tile_type[tile_pos] = selected_seed
	crop.set_cell(tile_pos, 0, Vector2i(stage, type))

func _on_melon_seed_button_pressed() -> void:
	selected_seed = TILE_TYPES[1]

func _on_corn_seed_button_pressed() -> void:
	selected_seed = TILE_TYPES[0]
