@tool
extends Node

var main: Main
var player: Player
var camera: Camera2D
var current_floor: Node2D
var minimap: MiniMap
var ui: UI
const room_size: Vector2 = Vector2(1440, 864)
const tile_size: float = 96.0

signal map_generated

func get_color(type: RoomGraph.RoomType) -> Color:
	match type:
		RoomGraph.RoomType.START:
			return Color(0, 0, 1)
		RoomGraph.RoomType.BOSS:
			return Color(1, 0, 0)
		RoomGraph.RoomType.REST:
			return Color(0, 1, 0)
		RoomGraph.RoomType.SHOP:
			return Color(0.7, 0.1, 0.4)
		
	return Color(0.6, 0.6, 0.6)
