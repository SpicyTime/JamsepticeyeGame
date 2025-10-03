extends StaticBody2D
@export var requires_key: bool = false
func _ready() -> void:
	# Change Sprite based on key requirement
	pass


func handle_interact(player: Player) -> void:
	if requires_key:
		if player.has_key:
			# Play animation
			# Make the signal play after animation
			SignalManager.level_complete.emit()
	else:
		# Play animation
		# Make the signal play after animation
		SignalManager.level_complete.emit()
