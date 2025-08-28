extends Node2D

signal hide_farm()

func _on_close_button_pressed() -> void:
	emit_signal("hide_farm")
