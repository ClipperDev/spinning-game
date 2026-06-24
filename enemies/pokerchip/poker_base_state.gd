extends BaseState
class_name PokerEnemyBaseState

var player = Global.player
var enemy: PokerEnemy

func _on_owner_set():
	enemy = handled_node as PokerEnemy
	assert(enemy != null, "Cannot use state, null enemy %s" % name)

func get_direction_to_player() -> int:
	if player.global_position.x < enemy.global_position:
		return 1
	else: return -1
