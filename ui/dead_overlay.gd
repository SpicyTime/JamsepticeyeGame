extends Control


func _on_restart_button_pressed() -> void:
	UiManager.hide_overlay("DeadOverlay")
	get_tree().paused = false
	for node in get_tree().get_nodes_in_group("Resetables"):
		node.reset()
