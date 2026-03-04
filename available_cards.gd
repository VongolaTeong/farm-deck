extends HBoxContainer

signal card_removed(data: CardData)

func _can_drop_data(position, data):
	return data is CardData

func _drop_data(position, data):
	card_removed.emit(data)
