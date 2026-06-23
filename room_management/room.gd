@tool
class_name Room extends Node2D

@export var room_id: StringName
@export var doors: Dictionary[int, DoorMarker] = {}
var enterance: int = -1

func _ready() -> void:
	assert(!doors.is_empty(), "NO DOORS IN ROOM " + room_id)
