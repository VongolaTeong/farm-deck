extends HBoxContainer

signal card_dropped(data: CardData)

func _can_drop_data(position, data):
	return data is CardData

func _drop_data(position, data):
	card_dropped.emit(data)
