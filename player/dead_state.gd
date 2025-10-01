extends Node
@export var  MAX_SPEED: float = 400.0
@export var  FRICTION: float = 1.0
@export var  ACCELERATION: float = 50.0
@export var texture: Texture2D = null
@onready var player: CharacterBody2D = $".."
var _seek_mana_drain: float = 0.2

func spirit_search() -> void:
	player.current_mana -= player.max_mana * _seek_mana_drain
	## Show the traps ##
	SignalManager.spirit_search.emit()
	
	

 
