extends GutTest

const FarmScene = preload("res://farm.tscn")

var farm
var crop_plot

func before_each():
	farm = FarmScene.instantiate()
	add_child(farm)
	await get_tree().process_frame
	crop_plot = farm.get_node("CropPlot")

func after_each():
	farm.queue_free()

# --- Stage Progression ---

func test_new_tile_starts_at_stage_zero():
	var pos = Vector2i(0, 0)
	assert_eq(crop_plot.tile_growth.get(pos, 0), 0)

func test_advance_tile_increases_stage_to_one():
	var pos = Vector2i(0, 0)
	crop_plot.advance_tile_growth(pos)
	assert_eq(crop_plot.tile_growth[pos], 1)

func test_tile_advances_through_all_four_stages():
	var pos = Vector2i(1, 0)
	for i in range(4):
		crop_plot.advance_tile_growth(pos)
	assert_eq(crop_plot.tile_growth[pos], 4)

func test_different_tiles_grow_independently():
	var pos_a = Vector2i(0, 0)
	var pos_b = Vector2i(2, 0)
	crop_plot.advance_tile_growth(pos_a)
	crop_plot.advance_tile_growth(pos_a)
	crop_plot.advance_tile_growth(pos_b)
	assert_eq(crop_plot.tile_growth[pos_a], 2)
	assert_eq(crop_plot.tile_growth[pos_b], 1)

# --- Harvest ---

func test_harvest_resets_tile_stage_to_zero():
	var pos = Vector2i(0, 1)
	for i in range(4):
		crop_plot.advance_tile_growth(pos)
	# Stage is 4 — next advance triggers harvest
	crop_plot.advance_tile_growth(pos)
	assert_eq(crop_plot.tile_growth[pos], 0)

func test_harvest_increments_corn_counter():
	var pos = Vector2i(1, 1)
	crop_plot.selected_seed = 0  # corn
	var before = crop_plot.harvested_crops[0]
	for i in range(5):  # 4 to reach stage 4, 1 to harvest
		crop_plot.advance_tile_growth(pos)
	assert_eq(crop_plot.harvested_crops[0], before + 1)

func test_harvest_increments_melon_counter():
	var pos = Vector2i(2, 1)
	crop_plot.selected_seed = 1  # melon
	var before = crop_plot.harvested_crops[1]
	for i in range(5):
		crop_plot.advance_tile_growth(pos)
	assert_eq(crop_plot.harvested_crops[1], before + 1)

func test_harvest_does_not_increment_wrong_crop_counter():
	var pos = Vector2i(3, 1)
	crop_plot.selected_seed = 0  # grow corn
	var melon_before = crop_plot.harvested_crops[1]
	for i in range(5):
		crop_plot.advance_tile_growth(pos)
	assert_eq(crop_plot.harvested_crops[1], melon_before)

func test_harvest_uses_tile_crop_type_not_selected_seed():
	# Plant corn, switch to melon before harvesting — corn counter must go up, not melon
	var pos = Vector2i(4, 1)
	crop_plot.selected_seed = 0
	for i in range(4):
		crop_plot.advance_tile_growth(pos)
	crop_plot.selected_seed = 1  # switch seed before harvest
	var corn_before = crop_plot.harvested_crops[0]
	var melon_before = crop_plot.harvested_crops[1]
	crop_plot.advance_tile_growth(pos)
	assert_eq(crop_plot.harvested_crops[0], corn_before + 1, "Corn counter should increment")
	assert_eq(crop_plot.harvested_crops[1], melon_before, "Melon counter should not change")

# --- Seed Type Mismatch ---

func test_wrong_seed_type_does_not_advance_existing_crop():
	var pos = Vector2i(0, 2)
	crop_plot.selected_seed = 0  # plant corn
	crop_plot.advance_tile_growth(pos)
	assert_eq(crop_plot.tile_growth[pos], 1)

	crop_plot.selected_seed = 1  # switch to melon — should be blocked
	crop_plot.advance_tile_growth(pos)
	assert_eq(crop_plot.tile_growth[pos], 1)

func test_matching_seed_type_continues_to_advance():
	var pos = Vector2i(1, 2)
	crop_plot.selected_seed = 0
	crop_plot.advance_tile_growth(pos)
	crop_plot.advance_tile_growth(pos)
	assert_eq(crop_plot.tile_growth[pos], 2)

func test_empty_tile_can_be_planted_with_any_seed():
	var pos_corn = Vector2i(0, 3)
	var pos_melon = Vector2i(1, 3)
	crop_plot.selected_seed = 0
	crop_plot.advance_tile_growth(pos_corn)
	crop_plot.selected_seed = 1
	crop_plot.advance_tile_growth(pos_melon)
	assert_eq(crop_plot.tile_growth[pos_corn], 1)
	assert_eq(crop_plot.tile_growth[pos_melon], 1)

# --- Seed Selection ---

func test_seed_selector_defaults_to_corn():
	assert_eq(crop_plot.selected_seed, 0)

func test_selecting_melon_seed_changes_selected_seed():
	crop_plot._on_melon_seed_button_pressed()
	assert_eq(crop_plot.selected_seed, 1)

func test_selecting_corn_seed_changes_selected_seed():
	crop_plot._on_melon_seed_button_pressed()
	crop_plot._on_corn_seed_button_pressed()
	assert_eq(crop_plot.selected_seed, 0)
