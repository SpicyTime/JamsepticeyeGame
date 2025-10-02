extends Node2D

func handle_interact() -> void:
	print("Handling interact")
	$Hitbox/CollisionShape2D.disabled = true
	$Interactable/Area2D/CollisionShape2D.disabled = true
