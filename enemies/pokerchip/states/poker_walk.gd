extends PokerEnemyBaseState
class_name PokerEnemyWalk


func enter(_data: Variant) -> void:
	enemy.alert = false
	
func physics_state(delta: float) -> StringName:
	handle_movement(enemy.direction, delta)
	print(enemy.direction)
	enemy.move_and_slide()
	gravity_fall()
	handle_rolling(delta)
	
	return NO_STATE
