extends Control
var resurrection_stones: Array[TextureRect] = []
var current_stone_index: int = 2
@onready var resurrect_stone_1: TextureRect = $Resurrections/ResurrectStone1
@onready var resurrection_stone_2: TextureRect = $Resurrections/ResurrectionStone2
@onready var resurrection_stone_3: TextureRect = $Resurrections/ResurrectionStone3
@onready var spirit_mana_bar: TextureProgressBar = $SpiritManaBar



func _ready() -> void:
	resurrection_stones = [resurrect_stone_1, resurrection_stone_2, resurrection_stone_3]
	# Removes a resurrection stone every time the player resurrects
	SignalManager.player_resurrect.connect(func():
		if current_stone_index >= 0:
			resurrection_stones[current_stone_index].visible = false
		current_stone_index -= 1
		)
	SignalManager.player_mana_changed.connect(func(value: float):
		spirit_mana_bar.value = value
		)
func reset() -> void:
	pass
