extends PlayerState
class_name PlayerJump

func enter(_data: Variant) -> void:
	player.can_jump = false
	player.velocity.y -= player.jump
	player.change_anim("jumpfall")
	
func physics_state(delta: float) -> StringName:
	apply_movement(delta, state_acceleration, state_friction)
	gravity_fall()
	player.move_and_slide()
	
	if player.is_on_floor():
		return &"idle"
	if Input.is_action_just_released("jump") or player.velocity.y > 0:
		return &"fall"

	return NO_STATE
	
func exit() -> void:
	player.velocity.y /= 2
