extends WheelEffect

func activate_specials() -> void:
	var healing = preload("res://wheel_slots/effects/zero_heal_effect.tscn").instantiate()
	player.get_node("status_effects").add_child(healing)
