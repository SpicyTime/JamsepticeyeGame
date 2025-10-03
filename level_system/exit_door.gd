extends StaticBody2D
@export var requires_key: bool = false
@export var soul_batteries_required: int = 0
var soul_batteries_filled: int = 0

func _ready() -> void:
	# Change Sprite based on key requirement
	pass


func handle_interact(player: Player) -> void:
	if not player.is_alive():
		return
		
	if requires_key or soul_batteries_required > 0:
		if player.has_key or soul_batteries_filled == soul_batteries_filled: 
			# Play animation
			# Make the signal play after animation
			SignalManager.level_complete.emit()
	else:
		# Play animation
		# Make the signal play after animation
		
		SignalManager.level_complete.emit()
