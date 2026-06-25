extends Node2D

## ATTENTION ATTACHED TO BULLET


func _process(delta: float) -> void:
	get_parent().damage += 2.22 * delta
