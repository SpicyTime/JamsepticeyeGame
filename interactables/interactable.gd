extends Node
class_name Interactable
var interactable_area: Area2D = null

func _ready() -> void:
	SignalManager.interacted.connect(_on_interact)
	interactable_area = get_child(0)
	interactable_area.connect("body_entered", _on_body_entered)
	interactable_area.connect("body_exited", _on_body_exited)
	
	
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		get_parent().add_to_group("Current Interactables")
		print("Interactable Entered")


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		get_parent().remove_from_group("Current Interactables")
		print("Interactable Exited")

func _on_interact(actor: Node2D) -> void:
	var parent: Node2D = get_parent()
	print(parent.is_in_group("Current Interactables"))
	print(actor == parent)
	if parent.is_in_group("Current Interactables") and actor == parent: 
		parent.handle_interact()
		
