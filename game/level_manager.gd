extends Node
var current_level_idx: int = 0
var level_copy: Level = null
var current_level: Level = null
var levels: Array[Level] = [
	preload("res://level_system/levels/level_1.tscn").instantiate(),
	preload("res://level_system/levels/level_2.tscn").instantiate(),
	
]
func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_0):
		reset_level()


func _ready() -> void:
	SignalManager.level_complete.connect(func ():
		current_level_idx += 1
		print(current_level_idx)
		enter_level(current_level_idx)
		)
	SignalManager.game_reset.connect(func ():
		reset_level()
		
		)
		
	call_deferred("enter_level", 0)

func reset_level() -> void:
	var path: String = current_level.scene_file_path

	if current_level and current_level.get_parent() == self:
		remove_child(current_level)
		levels[current_level_idx].queue_free()
	
	var new_level: Level = load(path).instantiate()
	add_child(new_level)
	current_level = new_level


func reset() -> void:
	reset_level()


func enter_level(level_idx: int) -> void:
	current_level_idx = level_idx 
	if level_idx != 0:
		exit_level(level_idx - 1)
	current_level = levels[level_idx]
	add_child(current_level)
	if is_instance_valid(current_level):
		current_level.enter()


func exit_level(level_idx: int) -> void:
	levels[level_idx].exit()
	
	remove_child(levels[level_idx])
