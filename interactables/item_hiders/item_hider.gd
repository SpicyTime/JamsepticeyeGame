extends Node2D
@export var item: Node2D = null
var item_revealed: bool = false
var reveal_mana_cost: int = 15
func _ready() -> void:
	SignalManager.swapped_live_mode.connect(func(alive):
		if not item:
			return
		if alive and not item_revealed:
			item.visible = false
		else:
			item.visible = true
		)


func break_box() -> void:
	SignalManager.alarm_item_broken.emit(90)
	queue_free()


func handle_interact(player: Player) -> void:
	if player.is_alive() and not item:
		break_box()
		return
		
	if not item_revealed and player.is_alive():
		item_revealed = true
		if item.has_method("enable_pickup"):
			item.enable_pickup()
		item.reparent(get_parent())
		item.visible = true
		#player.consume_mana(reveal_mana_cost)
		break_box()
		
		
