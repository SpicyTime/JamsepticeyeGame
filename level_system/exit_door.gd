extends StaticBody2D

func handle_interact() -> void:
	SignalManager.level_complete.emit()
