extends StaticBody2D
@export var requires_key: bool = false
@export var soul_batteries_required: int = 0
var soul_batteries_filled: int = 0
var falling_lock_texture: Texture2D = preload("res://level_system/textures/UnlockedLock.png")
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	if requires_key:
		animated_sprite.play("locked_door")
	else:
		animated_sprite.play("reg_door")


func handle_interact(player: Player) -> void:
	if not player.is_alive():
		return
		
	if requires_key or soul_batteries_required > 0:
		if player.has_key or (soul_batteries_filled == soul_batteries_filled and soul_batteries_required > 0): 
			# Play animation
			# Make the signal play after animation
			if player.has_key:
				animated_sprite.play("unlock_door")
				await animated_sprite.animation_finished
			
			animated_sprite.play("door_open")
			await animated_sprite.animation_finished
			SignalManager.level_complete.emit()
	else:
		animated_sprite.play("door_open")
		await animated_sprite.animation_finished
		SignalManager.level_complete.emit()
