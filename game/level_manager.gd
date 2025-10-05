extends Node
var current_level_idx: int = 0
var level_copy: Level = null
var current_level: Level = null
var levels: Array[PackedScene] = [
	preload("res://level_system/levels/level_1.tscn"),
	preload("res://level_system/levels/level_2.tscn"),
	preload("res://level_system/levels/level_3.tscn"),
	preload("res://level_system/levels/level_4.tscn"),
	preload("res://level_system/levels/level_5.tscn"),
	
]
func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_0):
		reset_level()


func _ready() -> void:
	SignalManager.level_complete.connect(func ():
		current_level_idx += 1
		print("Completed_level")
		enter_level(current_level_idx)
		)
	SignalManager.game_reset.connect(func ():
		reset_level()
		
		)
	SignalManager.reset_to_first_level.connect(func():
		enter_level(0)
		UiManager.show_overlay("Hud")
		UiManager.swap_menu("None")
		get_tree().paused = false
		)
	call_deferred("enter_level", 4)

func reset_level() -> void:
	var path: String = current_level.scene_file_path

	if current_level and current_level.get_parent() == self:
		remove_child(current_level)
		
	
	var new_level: Level = load(path).instantiate()
	add_child(new_level)
	current_level = new_level


func reset() -> void:
	reset_level()


func enter_level(level_idx: int) -> void:
	current_level_idx = level_idx 
	if level_idx != 0:
		exit_level(level_idx - 1)
	if level_idx >= levels.size():
		UiManager.swap_menu("WinScreen")
		UiManager.hide_overlay("Hud")
		get_tree().paused = true
		return
	current_level = levels[level_idx].instantiate()
	add_child(current_level)
	if is_instance_valid(current_level):
		current_level.enter()


func exit_level(level_idx: int) -> void:
	if current_level:
		current_level.exit()
		
		remove_child(current_level)
	if level_idx == levels.size():
		UiManager.swap_menu("WinScreen")
