class_name Pickup
extends Area2D

@export var wheel_slot: WheelSlot

func _ready() -> void:
	$Sprite2D.texture = wheel_slot.wheel_texture

func picked_up() -> void:
	if wheel_slot.suit == "jackpot":
		Global.player.get_node("gun_operator").replace_wheel_section(wheel_slot, 7, true)
	else:
		Global.player.ui.wheel.start_replacing(wheel_slot)
	#bring out the replacement menu
