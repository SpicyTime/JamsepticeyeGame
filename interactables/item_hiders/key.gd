extends Node2D
func handle_interact(player: Player) -> void:
	print("Handling interact")
	player.has_key = true
	queue_free()
	

func enable_pickup() -> void:
	$Interactable/Area2D/CollisionShape2D.disabled = false
	print("Enabling Pickup")
