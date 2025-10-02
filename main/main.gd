extends Node
@onready var ui_manager: CanvasLayer = $UIManager

func _ready() -> void:
	UiManager.set_up_ui(ui_manager)
