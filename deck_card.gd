extends Control

func set_card(data: CardData):
	$CardThumbnail.texture_normal = data.icon
