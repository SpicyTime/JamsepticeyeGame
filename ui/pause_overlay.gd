extends Control


func _on_resume_pressed() -> void:
	get_tree().paused = false
	#UiManager.hide_overlay("PauseOverlay")

func _on_quit_pressed() -> void:
	pass # Replace with function body.


func _on_restart_pressed() -> void:
	SignalManager.level_restart.emit()
