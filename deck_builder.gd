extends Node2D

@export var unlocked_cards: Array[CardData] = []
@export var deck_cards: Array[CardData] = []
@export var unlocked_card_scene: PackedScene
@export var deck_card_scene: PackedScene
@export var card_display_scene: PackedScene

func _ready():
	deck_card_scene = load("res://deck_card.tscn")
	unlocked_card_scene = load("res://deck_card.tscn")
	card_display_scene = load("res://card_display.tscn")

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
	
	deck_cards = []
	var container = $AvailableCardsScroll/AvailableCards
	var deck_container = $Deck/DeckCards
	
	for card in unlocked_cards:
		var card_instance = unlocked_card_scene.instantiate()
		card_instance.set_card(card)
		container.add_child(card_instance)

	for card in deck_cards:
		var card_instance = deck_card_scene.instantiate()
		card_instance.set_card(card)
		deck_container.add_child(card_instance)
		card_instance.card_clicked.connect(_on_card_clicked)
		
func _on_card_clicked(card_data: CardData):
	var card_display = card_display_scene.instantiate()
	card_display.set_card(card_data)
	add_child(card_display)

	# Optional: make sure it’s on top
	card_display.z_index = 999
