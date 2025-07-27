extends Node2D

@onready var crop_layers := get_crop_layers()

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		var click_pos = get_global_mouse_position()

		# Convert to tile coordinates (use any layer since all share the same grid)
		var tile_map := crop_layers[0]
		var tile_pos = tile_map.local_to_map(tile_map.to_local(click_pos))

		# Find current crop stage
		var current_stage: int = -1
		for i in crop_layers.size():
			if crop_layers[i].get_cell(0, tile_pos) != TileMap.INVALID_CELL:
				current_stage = i
				break

		# Advance crop to next stage
		if current_stage != -1 and current_stage + 1 < crop_layers.size():
			var tile_id = crop_layers[current_stage].get_cell(0, tile_pos)

			crop_layers[current_stage].set_cell(0, tile_pos, TileMap.INVALID_CELL)
			crop_layers[current_stage + 1].set_cell(0, tile_pos, tile_id)

func get_crop_layers() -> Array[TileMapLayer]:
	var layers := []
	for child in get_children():
		if child is TileMapLayer:
			layers.append(child)
	return layers
