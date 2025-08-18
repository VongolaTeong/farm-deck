extends Control

signal card_clicked(card_data: CardData)

var card_data: CardData

func set_card(data: CardData):
	$CardThumbnail.texture_normal = data.icon
	card_data = data

func _ready():
	$CardThumbnail.pressed.connect(_on_card_pressed)

func _on_card_pressed():
	emit_signal("card_clicked", card_data)
