class_name Room extends Node2D

@export var room_id: StringName
@export var doors: Array[DoorMarker] = []
var enterance: int

func _ready() -> void:
	assert(doors.size() != 0, "NO DOORS IN ROOM " + room_id)
	
