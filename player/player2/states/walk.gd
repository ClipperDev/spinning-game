extends PlayerState
class_name PlayerWalk

func enter(_data: Variant) -> void:
	player.can_jump = true
	

func physics_state(delta: float) -> StringName:
	apply_movement(delta, state_acceleration, state_friction)
	player.move_and_slide()
	
	if get_input_dir():
		if player.lookdir == get_input_dir():
			player.change_anim("walk_forwards")
		else: player.change_anim("walk_backwards")
	
	if not player.is_on_floor():
		return &"fall"
	if Input.is_action_just_pressed("jump") and player.can_jump:
		return &"jump"
	if not get_input_dir():
		return &"idle"

	return NO_STATE
	
func exit() -> void:
	player.change_anim("RESET")
