extends BaseState
class_name PlayerState

@export var state_acceleration: float = 0.0
@export var state_friction: float = 0.0
var player: Player

func _on_owner_set():
	player = handled_node as Player
	assert(player != null, "Cannot use state, null player %s" % name)
	
func get_input_dir() -> float:
	return Input.get_axis("left", "right")
	
func apply_movement(delta: float, acceleration: float, friction: float):
	var input_dir: float = get_input_dir()
	
	if input_dir != 0:
		player.velocity.x = move_toward(player.velocity.x, player.SPEED * input_dir, acceleration * delta)
	else: 
		player.velocity.x = move_toward(player.velocity.x, 0, friction * delta)
		
	player.body_pivot.scale.x = abs(player.body_pivot.scale.x) * player.lookdir

func gravity_fall(extra_gravity: float = 0.0):
	player.velocity.y += player.gravity + extra_gravity
