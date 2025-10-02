extends Node2D
var mana_cost: int = 20
var disabled: bool = false
var revealed: bool = false
func _ready() -> void:
	SignalManager.swapped_live_mode.connect(func(alive):
		print("Swtitched")
		if alive and not revealed:
			visible = false
		else:
			visible = true
			print("Showing")
		)
func handle_interact(player: Player) -> void:
	print("Handling interact")
	$Hitbox/CollisionShape2D.disabled = true
	$Interactable/Area2D/CollisionShape2D.disabled = true
	if not disabled:
		player.consume_mana(mana_cost)
	disabled = true
