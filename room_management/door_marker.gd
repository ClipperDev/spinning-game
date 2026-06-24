@tool
class_name DoorMarker extends Marker2D

@export var possible_rooms: Array[RoomChoice]
@onready var room: Room = get_parent() as Room
@export var door_id: int:
	set(value):
		if room == null:
			door_id = value
			return
		if value < 0:
			push_warning("Cannot use negative door_id")
			return
		if room.doors.has(value):
			push_error("Existing door id, ", value, " in ", room.room_id)
			return
		for id in room.doors.keys():
			if room.doors[id] == self:
				room.doors.erase(id)
		door_id = value
		room.doors[door_id] = self

func _ready() -> void:
	
	assert(!possible_rooms.is_empty(), "EMPTY [possible_rooms] DICTIONARY")
