class_name MapGenerator extends RefCounted

func generate_graph(rng: RandomNumberGenerator, floor_data: FloorData) -> RoomGraph:
	var graph: RoomGraph = RoomGraph.new()
	
	var main_path: Array[RoomGraph.RoomNode] = []
	for depth in range(floor_data.FLOOR_LENGTH):
		var type: RoomGraph.RoomType = _pick_room_type(depth, floor_data.FLOOR_LENGTH)
		var node: RoomGraph.RoomNode = graph.try_add_node(type, depth, 0)
		if node == null:
			continue
		node.world_pos = Vector2(depth, 0)
		if main_path.size() > 0:
			graph.connect_nodes(main_path.back().id, node.id)
		main_path.append(node)
		
	for i in range(1, main_path.size() - 1):
		if rng.randf() <= floor_data.BRANCH_CHANCE:
			var dir: int = 1 if rng.randf() > 0.5 else -1
			_generate_branch(graph, rng, main_path[i], dir, 1, floor_data)
			
		
	
		
	return graph

func _generate_branch(graph: RoomGraph,
 rng: RandomNumberGenerator,
 parent: RoomGraph.RoomNode,
 direction: int,
 lane: int,
floor_data: FloorData) -> void:
	if lane > floor_data.MAX_BRANCH_DEPTH:
		return
	var branch_path: Array[RoomGraph.RoomNode]
	var branch_length: int = rng.randi_range(floor_data.MIN_BRANCH_LENGTH, floor_data.MAX_BRANCH_LENGTH)
	var horizontal_dir: int = -1 if randf() <= 0.5 else 1
	for i in range(branch_length):
		var type: RoomGraph.RoomType = RoomGraph.RoomType.COMBAT
		var node: RoomGraph.RoomNode = graph.try_add_node(type, parent.depth + i * horizontal_dir, lane)
		if node == null:
			break
		node.world_pos = Vector2(parent.depth + i * horizontal_dir, direction * lane)
		if branch_path.size() > 0:
			graph.connect_nodes(branch_path.back().id, node.id)
		branch_path.append(node)
	
	for i in range(branch_path.size()):
		if rng.randf() <= floor_data.BRANCH_CHANCE:
			_generate_branch(graph, rng, branch_path[i], direction, lane + 1, floor_data)
	

func _pick_room_type(depth: int, total: int) -> RoomGraph.RoomType:
	if depth == 0:
		return RoomGraph.RoomType.START
	elif depth == total - 1:
		return RoomGraph.RoomType.BOSS
	
	return RoomGraph.RoomType.COMBAT
