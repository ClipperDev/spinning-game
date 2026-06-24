extends PlayerState
class_name PlayerFall

func enter(_data: Variant) -> void:
	player.change_anim("jumpfall")
	player.coyote_timer = player.coyote_time
	
	
func physics_state(_delta: float) -> StringName:
	
	apply_movement(_delta, state_acceleration, state_friction)
	gravity_fall(player.extra_gravity)
	player.move_and_slide()
	
	if Input.is_action_just_pressed("jump"):
		if player.coyote_timer > 0.0 and player.can_jump:
			return &"jump"
		player.jump_buffer_timer = player.jump_buffer
	
	player.jump_buffer_timer -= _delta
	player.coyote_timer -= _delta
	
	if player.is_on_floor():
		if player.jump_buffer_timer > 0.0:
			return &"jump"
		if abs(player.velocity.x) < 0.1 and get_input_dir() == 0.0:
			return &"idle"
		return &"walk"
	
	return NO_STATE
