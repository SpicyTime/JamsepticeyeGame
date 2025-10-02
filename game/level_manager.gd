extends Node
var current_level_idx: int = 0
var levels: Array[Level] = [
	preload("res://level_system/levels/level_1.tscn").instantiate(),
	
]

func _ready() -> void:
	SignalManager.level_complete.connect(func ():
		current_level_idx += 1
		enter_level(current_level_idx)
		)
	for level in levels:
		add_child(level)
		
	call_deferred("enter_level", 0)


func enter_level(level_idx: int) -> void:
	current_level_idx = level_idx 
	if level_idx != 0:
		exit_level(level_idx - 1)
	if is_instance_valid(levels[level_idx]):
		levels[level_idx].enter()


func exit_level(level_idx: int) -> void:
	levels[level_idx].exit()
