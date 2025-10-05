extends Control


func _on_reset_button_pressed() -> void:
	SignalManager.reset_to_first_level.emit()
