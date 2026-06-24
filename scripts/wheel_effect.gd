class_name WheelEffect
extends Node2D
## added in player's status_effects node


@onready var player = $"../.."

func _ready() -> void:
	on_roll_specials()

## overridable. only for one time on-roll effects
func on_roll_specials() -> void:
	pass
