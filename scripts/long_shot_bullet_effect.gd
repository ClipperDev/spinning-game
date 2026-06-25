extends Node2D

## ATTENTION ATTACHED TO BULLET
@export var dmg_per_px_per_s: float = 5.0
@onready var prev_pos: Vector2 = self.global_position

func _process(delta: float) -> void:
	var dist = (prev_pos - self.global_position).length()
	get_parent().damage += dmg_per_px_per_s * dist * delta
	# with 1400 speed this makes the boost 1,9444444 * dmg_per_px_per_s
	prev_pos = self.global_position
