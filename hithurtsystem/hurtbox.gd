extends Area2D
class_name HurtBox

func _on_area_entered(area: Area2D) -> void:
	if area is HitBox and get_parent().is_alive():
		pass
