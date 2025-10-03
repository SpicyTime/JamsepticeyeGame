extends Node
var current_level_idx: int = 0
var level_copy: Level = null
var current_level: Level = null
var levels: Array[Level] = [
	preload("res://level_system/levels/level_1.tscn").instantiate(),
	
]
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_0):
		reset_level()
func _ready() -> void:
	SignalManager.level_complete.connect(func ():
		current_level_idx += 1
		enter_level(current_level_idx)
		)
	for level in levels:
		level.visible = false
		level.process_mode = Node.PROCESS_MODE_DISABLED
		add_child(level)
		
	call_deferred("enter_level", 0)

func reset_level() -> void:
	print("Resetting")
	var path: String = current_level.scene_file_path
	print(path)

	if current_level and current_level.get_parent() == self:
		remove_child(current_level)
		current_level.queue_free()

	var new_level: Level = load(path).instantiate()
	add_child(new_level)
	current_level = new_level

func enter_level(level_idx: int) -> void:
	current_level_idx = level_idx 
	if level_idx != 0:
		exit_level(level_idx - 1)
	current_level = levels[level_idx]
	if is_instance_valid(current_level):
		current_level.enter()
	current_level.visible = true
	current_level.process_mode = Node.PROCESS_MODE_INHERIT
	level_copy = current_level


func exit_level(level_idx: int) -> void:
	levels[level_idx].exit()
