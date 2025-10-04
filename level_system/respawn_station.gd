extends Node2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
func _ready() -> void:
	animated_sprite.animation_finished.connect(func():
		if animated_sprite.animation == "activate":
			animated_sprite.play("idle_full")
		)
func handle_interact(player: Player):
	if not player.is_alive():
		animated_sprite.play("activate")
		
		player.swap_living_status(true)
		player.position = $PlayerSpawn.global_position
		
