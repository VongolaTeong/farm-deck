extends Node2D

@export var unlocked_cards: Array[CardData] = []
@export var card_scene = load("res://card_display.tscn")

func _ready():
	unlocked_cards = [
		load("res://resources/cards/scythe.tres"),
	]
	var container = $AvailableCards  # GridContainer
