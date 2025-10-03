extends Node2D

func handle_interact(player: Player):
	player.swap_living_status(true)
	player.position = $PlayerSpawn.global_position
