extends Node2D
@export var item: Node2D = null
var item_revealed: bool = false
var reveal_mana_cost: int = 15
func _ready() -> void:
	SignalManager.swapped_live_mode.connect(func(alive):
		if alive and not item_revealed:
			item.visible = false
		else:
			item.visible = true
		)
func handle_interact(player: Player) -> void:
	if not item_revealed:
		item_revealed = true
		if item.has_method("enable_pickup"):
			item.enable_pickup()
		item.reparent(get_parent())
		item.visible = true
		player.consume_mana(reveal_mana_cost)
		queue_free()
		
