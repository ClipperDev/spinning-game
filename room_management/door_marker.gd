class_name DoorMarker extends Marker2D

@export var possible_rooms: Dictionary[StringName, int] = {}

func _ready() -> void:
	
	assert(!possible_rooms.is_empty(), "EMPTY [possible_rooms] DICTIONARY")
