class_name main extends Control

const PLAYER = preload("uid://cd6fxjm4ouvsg")


func _ready() -> void:
	Global.player = PLAYER.instantiate()
	add_child(Global.player)
	
	Global.camera = PlayerCamera.new()
	add_child(Global.camera)
