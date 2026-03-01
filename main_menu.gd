extends Control

@onready var farm_scene = $"../Farm"
@onready var deck_builder_scene = $"../DeckBuilder"
@onready var main_menu_scene = $"../MainMenu"

func _on_farm_button_pressed() -> void:
	main_menu_scene.hide()
	farm_scene.show()

func _on_card_button_pressed() -> void:
	main_menu_scene.hide()
	deck_builder_scene.show()

func _on_deck_builder_hide_deck_builder() -> void:
	deck_builder_scene.hide()
	main_menu_scene.show()

func _on_farm_hide_farm() -> void:
	farm_scene.hide()
	main_menu_scene.show()
