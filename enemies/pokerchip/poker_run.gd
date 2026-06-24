extends PokerEnemyBaseState
class_name PokerEnemyRun

func enter(_data: Variant) -> void:
	enemy.alert = true
	enemy.aggro_timer.start()

func physics_state(delta: float) -> StringName:
	handle_movement(get_direction_to_player(), delta)
	enemy.move_and_slide()
	gravity_fall()
	handle_rolling(delta)
	
	if enemy.aggro_timer.time_left <= 0.0:
		return &"walk"
	
	return NO_STATE

func exit() -> void:
	enemy.aggro_timer.stop()
