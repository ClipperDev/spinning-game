@tool
class_name RoomHelper extends Control

var room_data: RoomData

func _ready() -> void:
	z_index = 100

func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	if room_data == null:
		return
	draw_rect(Rect2(Vector2(0, 0), Global.room_size), Global.get_color(room_data.type), false, 16.0)
	for room in room_data.doors:
		match room:
			RoomData.DoorDir.LEFT:
				draw_line(Vector2(Global.tile_size / 2.0, Global.room_size.y - Global.tile_size * 4),
				Vector2(Global.tile_size / 2.0, Global.room_size.y - Global.tile_size), Color.YELLOW, 16)
			RoomData.DoorDir.RIGHT:
				draw_line(Vector2(Global.room_size.x - Global.tile_size / 2.0, Global.room_size.y - Global.tile_size * 4),
				Vector2(Global.room_size.x - Global.tile_size / 2.0, Global.room_size.y - Global.tile_size), Color.YELLOW, 16)
			RoomData.DoorDir.TOP:
				draw_line(Vector2(Global.room_size.x / 2.0 - Global.tile_size * 1.5, Global.tile_size / 2.0),
				Vector2(Global.room_size.x / 2.0 + Global.tile_size * 1.5, Global.tile_size / 2.0), Color.YELLOW, 16)
			RoomData.DoorDir.BOTTOM:
				draw_line(Vector2(Global.room_size.x / 2.0 - Global.tile_size * 1.5, Global.room_size.y - Global.tile_size / 2.0),
				Vector2(Global.room_size.x / 2.0 + Global.tile_size * 1.5, Global.room_size.y - Global.tile_size / 2.0), Color.YELLOW, 16)
