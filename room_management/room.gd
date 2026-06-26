class_name Room extends Node2D

@export var room_data: RoomData
@onready var tilemap: TileMapLayer = $TileMapLayer

func _ready() -> void:
	assert(tilemap != null and room_data != null, "NULL TILEMAP OR RoomData in " + name)
