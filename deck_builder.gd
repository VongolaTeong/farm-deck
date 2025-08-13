extends Node2D

@export var unlocked_cards: Array[CardData] = []
@export var deck_card_scene: PackedScene

func _ready():
	deck_card_scene = load("res://deck_card.tscn")
	# todo: get from stored json or other storage instead of hardcoded
	unlocked_cards = [
		load("res://resources/cards/scythe.tres"),
		load("res://resources/cards/watering_can.tres"),
		load("res://resources/cards/scarecrow.tres"),
		load("res://resources/cards/corn_cob.tres"),
		load("res://resources/cards/watering_can.tres"),
		load("res://resources/cards/watering_can.tres"),
		load("res://resources/cards/watering_can.tres")
	]
	var container = $AvailableCardsScroll/AvailableCards
	
	for card in unlocked_cards:
		var card_instance = deck_card_scene.instantiate()
		card_instance.set_card(card)
		container.add_child(card_instance)
