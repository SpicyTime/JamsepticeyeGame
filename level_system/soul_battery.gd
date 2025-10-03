extends StaticBody2D
var mana_cost: int = 33
var filled: bool = false

func handle_interact(player: Player):
	if not player.is_alive() and player.current_mana > mana_cost and not filled:
		SignalManager.soul_battery_filled.emit()
		player.consume_mana(mana_cost)
		filled = true
	
