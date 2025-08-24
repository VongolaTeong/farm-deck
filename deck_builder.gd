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
	deck_container.card_dropped.connect(_on_card_dropped)
	container.card_removed.connect(_on_card_removed)
	
	for card in unlocked_cards:
		var card_instance = unlocked_card_scene.instantiate()
		card_instance.set_card(card)
		container.add_child(card_instance)
		card_instance.card_clicked.connect(_on_card_clicked)

	for card in deck_cards:
		var card_instance = deck_card_scene.instantiate()
		card_instance.set_card(card)
		deck_container.add_child(card_instance)
		card_instance.card_clicked.connect(_on_card_clicked)
		
func _on_card_clicked(card_data: CardData):
	var card_display = card_display_scene.instantiate()
	card_display.set_card(card_data)
	add_child(card_display)

	card_display.z_index = 999

func _on_card_dropped(card_data: CardData):
	# todo: maybe allow certain amount of duplicates
	if card_data in deck_cards:
		print("Card already in deck, skipping")
		return
	deck_cards.append(card_data)
	var card_instance = deck_card_scene.instantiate()
	card_instance.set_card(card_data)
	$Deck/DeckCards.add_child(card_instance)

func _on_card_removed(card_data: CardData):
	print("on card remove", card_data)
	var idx = deck_cards.find(card_data)
	if idx != -1:
		deck_cards.remove_at(idx)
		
	for node in $Deck/DeckCards.get_children():
		if node.card_data == card_data:
			node.queue_free()
