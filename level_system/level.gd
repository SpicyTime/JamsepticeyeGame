extends Node2D
class_name Level
var alarm_triggered: bool = false
@export var show_tutorial: bool = false
func _ready() -> void:
	SignalManager.alarm_triggered.connect(_on_alarm_triggered)
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
	SignalManager.alarm_triggered.disconnect(_on_alarm_triggered)


func _on_alarm_triggered():
	if alarm_triggered:
		return
	print(get_tree())
	print(name)
	alarm_triggered = true
	for i in range(5):
		$AlarmShader.visible = true
		if get_tree(): await get_tree().create_timer(0.3).timeout
		$AlarmShader.visible = false
		if get_tree(): await get_tree().create_timer(0.5).timeout
	UiManager.show_overlay("CaughtOverlay")
	if get_tree(): get_tree().paused = true
