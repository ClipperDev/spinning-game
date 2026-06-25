class_name RoomGraph extends RefCounted

enum RoomType {START, COMBAT, REST, BOSS, SHOP}

class RoomNode:
	var id: int
	var type: RoomType
	var coords: Vector2i
	var connections: Array[int] = []
	var world_pos: Vector2 = Vector2.ZERO
	var scene_id: StringName = ""
	var placed: bool = false

var start: RoomNode
var nodes: Dictionary[int, RoomNode] = {}
var next_id: int
var occupied: Dictionary[Vector2i, RoomNode] = {}

func _add_node(type: RoomType, coords: Vector2i) -> RoomNode:
	var node: RoomNode = RoomNode.new()
	node.type = type
	node.coords = coords
	node.id = next_id
	nodes[next_id] = node
	next_id += 1
	return node

func try_add_node(type: RoomType, coords: Vector2i) -> RoomNode:
	if is_occupied(coords):
		return null
	var node: RoomNode = _add_node(type, coords)
	occupied[coords] = node
	return node

func is_occupied(coords: Vector2i) -> bool:
	if occupied.has(coords):
		return true
	return false
		

func connect_nodes(a: int, b: int) -> void:
	nodes[a].connections.append(b)
	nodes[b].connections.append(a)
