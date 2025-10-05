extends Node2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
const MECHANICAL_HUM = preload("res://level_system/mechanical-hum-64405.mp3")
const CLICK = preload("res://level_system/click-2-107422.mp3")

var filled: bool = false
func _ready() -> void:
	animated_sprite.animation_finished.connect(func():
		if animated_sprite.animation == "activate":
			animated_sprite.play("idle_full")
			SignalManager.respawn_station_filled.emit(self)
			filled = true
		)
	$MechanicalHum.stream = MECHANICAL_HUM
	$Click.stream = CLICK
func _process(delta: float) -> void:
	if filled and not $MechanicalHum.playing:
		$MechanicalHum.play()
func handle_interact(player: Player):
	if not player.is_alive():
		animated_sprite.play("activate")
		
		player.swap_living_status(true)
		
		player.position = $Marker2D.global_position
		#SignalManager.alarm_item_broken.emit(20)
		
		
		
		


func _on_animated_sprite_frame_changed() -> void:
	if animated_sprite.animation == "activate":
		if animated_sprite.frame == 1:
			$Click.pitch_scale = 2.0
			$Click.play()
		elif animated_sprite.frame == 2:
			$Click.pitch_scale = 1.0
			$Click.play()
