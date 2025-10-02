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
