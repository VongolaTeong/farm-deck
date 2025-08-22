extends HBoxContainer

signal card_dropped(data: CardData)

func _can_drop_data(position, data):
	# Only accept if it's CardData
	return data is CardData

func _drop_data(position, data):
	if data is CardData:
		emit_signal("card_dropped", data)
