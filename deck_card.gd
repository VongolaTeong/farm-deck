extends Control

func set_card(data: CardData, is_detailed: bool = false):
	# Set shared info
	$CardThumbnail.texture_normal = data.icon
