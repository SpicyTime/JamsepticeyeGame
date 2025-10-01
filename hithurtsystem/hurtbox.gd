extends Area2D
class_name HurtBox

func _on_area_entered(area: Area2D) -> void:
	if area is HitBox:
		get_parent().swap_living_status(false)
		print("Hit")
