@tool
class_name Main extends Control

const PLAYER = preload("uid://c5coxd37o8782")
@export_tool_button("Generate Map")
var map: Callable = RoomManager.generate_map


func _ready() -> void:
	Global.main = self
	print()
	

	
	
	Global.player = PLAYER.instantiate()
	RoomManager.generate_map()
	Global.player.global_position = Vector2(200, 200)
	add_child(Global.player)
	
	
	Global.camera = PlayerCamera.new()
	add_child(Global.camera)
