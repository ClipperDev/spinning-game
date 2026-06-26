@tool
class_name Room extends Node2D

@export var room_data: RoomData:
	set(value):
		if room_helper:
			room_helper.room_data = value
		room_data = value
		

var room_helper: RoomHelper

func _ready() -> void:
	if Engine.is_editor_hint():
		room_helper = RoomHelper.new()
		room_helper.room_data = room_data
		add_child(room_helper)
