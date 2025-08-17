extends Node2D

var card_data: CardData

func set_card(data: CardData):
	card_data = data
	$Control/CardArt.texture = data.icon
	$Control/CardName.text = data.name
	$Control/CardDescription.text = data.description
