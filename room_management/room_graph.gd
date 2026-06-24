class_name RoomGraph extends RefCounted

enum RoomType {START, COMBAT, REST, BOSS}

class RoomNode:
	var id: int
	var type: RoomType
	var depth: int
	var branch: int
	var connections: Array[int] = []
	var world_pos: Vector2 = Vector2.ZERO
	var scene_id: StringName = ""
	var placed: bool = false
	
var nodes: Dictionary[int, RoomNode] = {}
var next_id: int
var occupied: Dictionary[Vector2i, RoomNode] = {}

func _add_node(type: RoomType, depth: int, branch: int) -> RoomNode:
	var node: RoomNode = RoomNode.new()
	node.type = type
	node.depth = depth
	node.branch = branch
	node.id = next_id
	nodes[next_id] = node
	next_id += 1
	return node

func try_add_node(type: RoomType, depth: int, branch: int) -> RoomNode:
	var key: Vector2i = Vector2i(depth, branch)
	if occupied.has(key):
		return null
	var node: RoomNode = _add_node(type, depth, branch)
	occupied[key] = node
	return node

func connect_nodes(a: int, b: int) -> void:
	nodes[a].connections.append(b)
	nodes[b].connections.append(a)
