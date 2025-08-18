extends Control

var card_data: CardData

func set_card(data: CardData):
	card_data = data
	$CardPanel/CardArt.texture = data.icon
	$CardPanel/CardName.text = data.name
	$CardPanel/CardDescription.text = data.description

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		# Convert local event.position (relative to this Control) into global coordinates
		var global_pos = get_global_mouse_position()
		var card_rect = $CardPanel.get_global_rect()

		if not card_rect.has_point(global_pos):
			queue_free()  # Close card_display
