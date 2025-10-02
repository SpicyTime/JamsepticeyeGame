extends Node2D
var reveal_mana_cost: int = 20
var disable_mana_cost: int = 40
var disabled: bool = false
var revealed: bool = false
func _ready() -> void:
	SignalManager.swapped_live_mode.connect(func(alive):
		if alive and not revealed:
			visible = false
		else:
			visible = true
		)


func handle_interact(player: Player) -> void:
	if not revealed:
		player.consume_mana(reveal_mana_cost)
		revealed = true
		return
	if not disabled:
		$Hitbox/CollisionShape2D.disabled = true
		$Interactable/Area2D/CollisionShape2D.disabled = true
		player.consume_mana(disable_mana_cost)
		disabled = true
