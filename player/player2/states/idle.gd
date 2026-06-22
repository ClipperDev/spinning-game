extends PlayerState
class_name PlayerIdle

func enter(_data: Variant) -> void:
	player.can_jump = true
	player.change_anim("idle")
	
func physics_state(_delta: float) -> StringName:
	apply_movement(_delta, state_acceleration, state_friction)
	player.move_and_slide()
	if not player.is_on_floor():
		return &"fall"
		
	if Input.is_action_just_pressed("jump") and player.can_jump:
		return &"jump"
		
	if get_input_dir() != 0:
		return &"walk"
	
	return NO_STATE
	
func exit() -> void:
	player.change_anim("RESET")
