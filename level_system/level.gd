extends Node2D
class_name Level
var alarm_triggered: bool = false
@export var show_tutorial: bool = false
func _ready() -> void:
	SignalManager.alarm_triggered.connect(func():
		if alarm_triggered:
			return
		alarm_triggered = true
		for i in range(5):
			$AlarmShader.visible = true
			await get_tree().create_timer(0.3).timeout
			$AlarmShader.visible = false
			await get_tree().create_timer(0.5).timeout
		UiManager.show_overlay("CaughtOverlay")
		get_tree().paused = true
		)
	if show_tutorial:
		UiManager.show_overlay("TutorialOverlay")


func reset() -> void:
	var body_sprite: Sprite2D = get_node("DeadBodySprite")
	if body_sprite:
		body_sprite.queue_free()


func enter() -> void:
	if show_tutorial:
		UiManager.show_overlay("TutorialOverlay")
	else:
		UiManager.hide_overlay("TutorialOverlay")

func exit() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	var body_sprite: Sprite2D = get_node("DeadBodySprite")
	if body_sprite:
		body_sprite.queue_free()
