extends Node
class_name Interactable
var interactable_area: Area2D = null

func _ready() -> void:
	SignalManager.interacted.connect(_on_interact)
	interactable_area = get_child(0)
	interactable_area.connect("_on_body_entered", _on_body_entered)
	interactable_area.connect("_on_body_exited", _on_body_exited)
	
	
func _on_body_entered() -> void:
	get_parent().add_to_group("Current Interactables")


func _on_body_exited() -> void:
	get_parent().remove_from_group("Current Interactables")


func _on_interact(actor: Node2D) -> void:
	var parent: Node2D = get_parent()
	if parent.is_in_group("Current Interactables") and actor == parent: 
		parent.handle_interact()
		
