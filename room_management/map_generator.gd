class_name MapGenerator extends RefCounted


func generate_graph(rng: RandomNumberGenerator, floor_data: FloorData) -> RoomGraph:
	var graph: RoomGraph
	var attempts: int = 0
	var total_rooms: int = 0
	while attempts <= 100:
		graph = _attempt_generate_graph(rng, floor_data, attempts)
		var count: int = graph.nodes.size()
		total_rooms += graph.nodes.size()
		if count >= floor_data.MIN_ROOMS and count <= floor_data.MAX_ROOMS:
			attempts += 1
			_assign_boss(graph, rng)
			if not _assign_shop(graph, rng): continue
			if not _assign_rest(graph, rng): continue
			print_rich("[color=green]Finished on attempt -> ", attempts)
			print_rich("[color=white]Room Count -> [color=yellow]", count)
			print_rich("[color=white]Average Room Count -> [color=yellow] %0.2f" % (total_rooms/float(attempts)))
			return graph
		attempts += 1
		
	push_error("Ran out of attempts to generate map for floor -> ", floor_data.FLOOR_INDEX)
	print_rich("[color=orange]Average Room Count -> [color=red]", total_rooms/float(attempts))
	return null



func _attempt_generate_graph(rng: RandomNumberGenerator, floor_data: FloorData, salt: int) -> RoomGraph:
	var local_rng: RandomNumberGenerator = RandomNumberGenerator.new()
	local_rng.seed = rng.seed + salt
	var graph: RoomGraph = RoomGraph.new()
	
	var main_path: Array[RoomGraph.RoomNode] = []
	main_path.append(graph.try_add_node(RoomGraph.RoomType.START, Vector2i(0, 0)))
	graph.start = main_path[0]
	for depth in range(1, floor_data.FLOOR_LENGTH):
		var type: RoomGraph.RoomType = RoomGraph.RoomType.COMBAT
		var node: RoomGraph.RoomNode = graph.try_add_node(type, Vector2i(depth, 0))
		if main_path.size() > 0:
			graph.connect_nodes(main_path.back().id, node.id)
		main_path.append(node)
		
	for i in range(1, main_path.size() - 1):
		var roll: float = local_rng.randf()
		if roll > floor_data.BRANCH_CHANCE:
			continue
		var y: int = 1 if local_rng.randf() > 0.5 else -1
		_generate_branch(graph, local_rng, main_path[i], y, floor_data)
		if roll <= floor_data.DOUBLE_BRANCH_CHANCE:
			_generate_branch(graph, local_rng, main_path[i], -y, floor_data)
			
			
		
	return graph

func _generate_branch(graph: RoomGraph,
 rng: RandomNumberGenerator,
 parent: RoomGraph.RoomNode,
 target_y: int,
floor_data: FloorData) -> void:
	if abs(target_y) > floor_data.MAX_BRANCH_DEPTH:
		return
	var branch_path: Array[RoomGraph.RoomNode] = []
	var branch_length: int = rng.randi_range(floor_data.MIN_BRANCH_LENGTH, floor_data.MAX_BRANCH_LENGTH)
	var horizontal_dir: int = -1 if rng.randf() <= 0.5 else 1
	for i in range(branch_length):
		var type: RoomGraph.RoomType = RoomGraph.RoomType.COMBAT
		var node: RoomGraph.RoomNode = graph.try_add_node(type, Vector2i(parent.coords.x + i * horizontal_dir, target_y))
		if node == null:
			break
		if branch_path.size() > 0:
			graph.connect_nodes(branch_path.back().id, node.id)
		branch_path.append(node)
	
	if branch_path.is_empty():
		return
	graph.connect_nodes(branch_path[0].id, parent.id)
	
	
	for i in range(branch_path.size()):
		var roll: float = rng.randf()
		if roll > floor_data.BRANCH_CHANCE:
			continue
		var deeper_y: int = target_y + sign(target_y)
		var shallower_y: int = target_y - sign(target_y)
		
		var deeper_free: bool = not graph.is_occupied(Vector2i(branch_path[i].coords.x, deeper_y))
		var shallower_free: bool = not graph.is_occupied(Vector2i(branch_path[i].coords.x, shallower_y))
		
		var preffer_deeper: bool = rng.randf() > 0.5
		var primary_y: int = deeper_y if preffer_deeper else shallower_y
		var fallback_y: int = shallower_y if preffer_deeper else deeper_y
		var primary_free: bool = deeper_free if preffer_deeper else shallower_free
		var fallback_free: bool = shallower_free if preffer_deeper else deeper_free
		
		if primary_free:
			_generate_branch(graph, rng, branch_path[i], primary_y, floor_data)
			
			if fallback_free and roll <= floor_data.DOUBLE_BRANCH_CHANCE:
				_generate_branch(graph, rng, branch_path[i], fallback_y, floor_data)
		elif fallback_free:
			_generate_branch(graph, rng, branch_path[i], fallback_y, floor_data)
	
func _assign_boss(graph: RoomGraph, rng: RandomNumberGenerator) -> void:
	var start_node: RoomGraph.RoomNode = graph.start
	if start_node == null:
		return
	
	var candidates: Array[RoomGraph.RoomNode] = []
	
	for node in graph.nodes.values():
		node = node as RoomGraph.RoomNode
	
		if node.type != RoomGraph.RoomType.COMBAT: continue
		
		if node.connections.size() != 1: continue
		var neighbour: RoomGraph.RoomNode = graph.nodes[node.connections[0]]
		if neighbour.coords.y != node.coords.y: continue
		candidates.append(node)

	assert(not candidates.is_empty(), "COULD NOT GENERATE BOSS ROOM")
	
	var max_distance: float = -1
	for node in candidates:
		var dist: float = start_node.coords.distance_to(node.coords)
		if dist > max_distance:
			max_distance = dist
	var threshold: float = max_distance * 0.75
	var eligible: Array[RoomGraph.RoomNode] = candidates.filter(func(node: RoomGraph.RoomNode):
		return start_node.coords.distance_to(node.coords) >= threshold
		)

	assert(not eligible.is_empty(), "COULD NOT GENERATE BOSS ROOM")
	var boss: RoomGraph.RoomNode = eligible[rng.randi_range(0, eligible.size() - 1)]
	boss.type = RoomGraph.RoomType.BOSS
	graph.boss = boss

func _assign_shop(graph: RoomGraph, rng: RandomNumberGenerator) -> bool:
	
	var candidates: Array[RoomGraph.RoomNode] = []
	
	for node in graph.nodes.values():
		node = node as RoomGraph.RoomNode
	
		if node.type != RoomGraph.RoomType.COMBAT: continue
		
		if node.connections.size() != 1: continue
		var neighbour: RoomGraph.RoomNode = graph.nodes[node.connections[0]]
		if neighbour.coords.y != node.coords.y: continue
		candidates.append(node)
		
	if candidates.is_empty(): return false
	
	var shop: RoomGraph.RoomNode = candidates[rng.randi_range(0, candidates.size() - 1)]
	shop.type = RoomGraph.RoomType.SHOP
	graph.shop = shop
	return true

func _assign_rest(graph: RoomGraph, rng: RandomNumberGenerator) -> bool:
	
	var boss: RoomGraph.RoomNode = graph.boss
	if boss == null:
		return false
	var threshold: float = graph.start.coords.distance_to(boss.coords) * 0.8
	var candidates: Array[RoomGraph.RoomNode] = []
	for node in graph.nodes.values():
		node = node as RoomGraph.RoomNode
	
		if node.type != RoomGraph.RoomType.COMBAT: continue
		
		if node.connections.size() == 2:
			if !(graph.nodes[node.connections[0]].coords.y == node.coords.y and 
			graph.nodes[node.connections[1]].coords.y == node.coords.y):
				continue
			if graph.nodes[node.connections[0]].type == RoomGraph.RoomType.BOSS or graph.nodes[node.connections[1]].type == RoomGraph.RoomType.BOSS:
				continue
			if graph.nodes[node.connections[0]].type == RoomGraph.RoomType.SHOP or graph.nodes[node.connections[1]].type == RoomGraph.RoomType.SHOP:
				continue
		elif node.connections.size() == 1:
			if graph.nodes[node.connections[0]].coords.y != node.coords.y:
				continue
		else:
			continue
		if not graph.start.coords.distance_to(node.coords) >= threshold:
			continue
		
		candidates.append(node)
		
	if candidates.is_empty(): return false
	
	var rest: RoomGraph.RoomNode = candidates[rng.randi_range(0, candidates.size() - 1)]
	rest.type = RoomGraph.RoomType.REST
	graph.rest = rest
	
	return true
