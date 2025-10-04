extends Control
var resurrection_stones: Array[TextureRect] = []
var current_stone_index: int = 2
var progress_frames: Array[ImageTexture] = []
var frame_size := Vector2i(16, 35)
var frame_index: int = 0
var frame_time: float = 0.0
var frame_duration: float = 0.6 # seconds per frame (10 fps)
@onready var resurrect_stone_1: TextureRect = $Resurrections/ResurrectStone1
@onready var resurrection_stone_2: TextureRect = $Resurrections/ResurrectionStone2
@onready var resurrection_stone_3: TextureRect = $Resurrections/ResurrectionStone3
@onready var spirit_mana_bar: TextureProgressBar = $SpiritManaBar
@onready var security_awareness_label: Label = $HBoxContainer/SecurityAwarenessLabel
@onready var guard_icon: TextureRect = $HBoxContainer/GuardIcon

const ALERT_GUARD = preload("uid://xep22narguod")
const AWAKE_GUARD = preload("uid://cmvttuc0ebjkm")
const HALF_ALERT_GUARD = preload("uid://covat0umt0pss")
const HALF_ASLEEP_GUARD = preload("uid://rq4ueqg4x8jg")
const SLEEPING_GUARD = preload("uid://dnk7j2n1ph1p7")

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
	
	SignalManager.alarm_item_broken.connect(_on_alarm_item_broken)
	$RemoveAwarenessTimer.timeout.connect(func():
		var security_awareness: int = int(security_awareness_label.text)
		security_awareness -= 1
		if security_awareness > 0:
			security_awareness_label.text = str(security_awareness) + "%"
		)
	SignalManager.game_reset.connect(func ():
		UiManager.show_overlay("Hud")
		
		update_security_awareness(0)
		)
	set_up_animated_mana_bar()
	animate_progress_bar(0)
	
func _process(delta: float) -> void:
	frame_time += delta
	if frame_time >= frame_duration:
		frame_time = 0.0
		frame_index = (frame_index + 1) % progress_frames.size()
		spirit_mana_bar.texture_progress = progress_frames[frame_index]


func update_security_awareness(security_awareness: int) -> void:
	security_awareness_label.text = str(security_awareness) + "%"
	if security_awareness >= 100:
		guard_icon.texture = ALERT_GUARD
		SignalManager.alarm_triggered.emit()
		UiManager.hide_overlay("Hud")
		
	elif security_awareness > 75:
		guard_icon.texture = HALF_ALERT_GUARD
		security_awareness_label.add_theme_color_override("font_color", Color(0.6, 0, 0, 1))
	elif security_awareness > 50:
		guard_icon.texture = AWAKE_GUARD
		security_awareness_label.add_theme_color_override("font_color", Color(1, 0, 0, 1))
	elif security_awareness > 25:
		guard_icon.texture = HALF_ASLEEP_GUARD
		security_awareness_label.add_theme_color_override("font_color", Color(1, 1, 0, 1))
	else:
		guard_icon.texture = SLEEPING_GUARD
		security_awareness_label.add_theme_color_override("font_color", Color(0, 1, 0, 1))

func set_up_animated_mana_bar() -> void:
	# Keep original texture
	var sheet: Image = preload("res://ui/textures/Progress.png").get_image()

	# Slice all frames into an array
	var frame_count = sheet.get_width() / frame_size.x
	for i in range(frame_count):
		var frame_img = Image.create(frame_size.x, frame_size.y, false, Image.FORMAT_RGBA8)
		frame_img.blit_rect(sheet, Rect2i(Vector2i(frame_size.x * i, 0), frame_size), Vector2i.ZERO)
		progress_frames.append(ImageTexture.create_from_image(frame_img))

func animate_progress_bar(frame: int) -> void:
	spirit_mana_bar.texture_progress = progress_frames[frame]

	
func reset() -> void:
	for resurrection_stone in resurrection_stones:
		resurrection_stone.visible = true
	current_stone_index = 0
	update_security_awareness(0)
	UiManager.show_overlay(self.name)


func _on_alarm_item_broken(alarm_increase: int) -> void:
	
		var security_awareness: int = int(security_awareness_label.text)
		security_awareness += alarm_increase
		update_security_awareness(security_awareness)
		
		
