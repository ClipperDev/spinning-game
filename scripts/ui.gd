@tool
class_name UI extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.ui = self
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

#should update the wheel when called
func update_slots_icons() -> void:
	pass
