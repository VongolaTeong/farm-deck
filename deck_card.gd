extends Control

signal card_clicked(card_data: CardData)

var card_data: CardData

func set_card(data: CardData):
	$CardThumbnail.texture_normal = data.icon
	card_data = data

func _ready():
	$CardThumbnail.pressed.connect(_on_card_pressed)

func _on_card_pressed():
	card_clicked.emit(card_data)

func _get_drag_data(at_position: Vector2) -> Variant:
	var drag_preview = duplicate()  # Make a visual copy
	drag_preview.modulate = Color(1, 1, 1, 0.5)
	set_drag_preview(drag_preview)
	return card_data
