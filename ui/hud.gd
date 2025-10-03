extends Control
var resurrection_stones: Array[TextureRect] = []
var current_stone_index: int = 2
@onready var resurrect_stone_1: TextureRect = $Resurrections/ResurrectStone1
@onready var resurrection_stone_2: TextureRect = $Resurrections/ResurrectionStone2
@onready var resurrection_stone_3: TextureRect = $Resurrections/ResurrectionStone3
@onready var spirit_mana_bar: TextureProgressBar = $SpiritManaBar
@onready var security_awareness_label: Label = $SecurityAwarenessLabel

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
	SignalManager.alarm_item_broken.connect(func(alarm_increase: int):
		var security_awareness: int = int(security_awareness_label.text)
		security_awareness += alarm_increase
		security_awareness_label.text = str(security_awareness) + "%"
		if security_awareness > 25:
			security_awareness_label.add_theme_color_override("font_color", Color(1, 1, 0, 1))
		if security_awareness > 50:
			security_awareness_label.add_theme_color_override("font_color", Color(1, 0, 0, 1))
		if security_awareness > 75:
			security_awareness_label.add_theme_color_override("font_color", Color(0.6, 0, 0, 1))
		)

func reset() -> void:
	pass
