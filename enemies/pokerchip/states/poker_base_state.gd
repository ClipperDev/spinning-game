extends BaseState
class_name PokerEnemyBaseState

@export var state_acceleration: float = 0.0 
@export var state_friction: float = 0.0 

var player = Global.player
var enemy: PokerEnemy


func _on_owner_set():
	enemy = handled_node as PokerEnemy
	assert(enemy != null, "Cannot use state, null enemy %s" % name)

func get_direction_to_player() -> int:
	if Global.player.global_position.x < enemy.global_position.x:
		return -1
	else: return 1

func get_random_direction() -> int:
	return 0
	
func handle_movement(move_direction: float, delta: float) -> void:
	if move_direction:
		enemy.velocity.x = move_toward(enemy.velocity.x, move_direction * enemy.current_speed, state_acceleration * delta)
	else:
		enemy.velocity.x = move_toward(enemy.velocity.x, 0, state_friction * delta)

func gravity_fall(extra_gravity: float = 0.0):
	enemy.velocity.y += enemy.gravity + extra_gravity

func handle_rolling(delta: float):
	enemy.body.rotation += 0.01 * enemy.velocity.x * delta
	
func jump(jump_force: float):
	enemy.velocity.y -= jump_force
