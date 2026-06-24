extends PokerEnemyBaseState
class_name PokerEnemyWalk


func enter(_data: Variant) -> void:
	enemy.alert = false
	
func physics_state(delta: float) -> StringName:
	handle_movement(enemy.direction, delta)
	enemy.move_and_slide()
	gravity_fall()
	handle_rolling(delta)
	
	if enemy.alert:
		return &"run"
	
	return NO_STATE
