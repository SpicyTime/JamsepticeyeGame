extends StaticBody2D
@export var respawn_station: Node2D = null
func _ready() -> void:
	SignalManager.respawn_station_filled.connect(func(station_node: StaticBody2D):
		if station_node == respawn_station:
			deactivate()
		)

func deactivate() -> void:
	set_collision_layer_value(2, false)
