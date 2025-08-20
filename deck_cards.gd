extends HBoxContainer

func _can_drop_data(position, data):
	# Only accept if it's CardData
	return data is CardData

func _drop_data(position, data):
	if data is CardData:
		# Create a new card instance inside the deck
		var card_scene = preload("res://deck_card.tscn")
		var card_instance = card_scene.instantiate()
		card_instance.set_card(data)
		add_child(card_instance)
