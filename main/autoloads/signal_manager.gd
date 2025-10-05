extends Node
#Player
signal player_mana_changed(value: float)
signal interacted(actor: Node2D)
signal swapped_live_mode(alive: bool)
signal spirit_search
signal player_fully_dead
signal player_resurrect
signal mana_consumed 
# Level System
signal level_complete
signal alarm_item_broken(value: int)
signal alarm_triggered
signal respawn_station_filled
signal level_restart
signal game_reset
signal reset_to_first_level
