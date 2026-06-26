class_name MiniMap extends Control

@export var MINIMAP_SIZE: Vector2 = Vector2(300, 200)
@export var MINIMAP_MARGIN: float = 32.0
@export var MINIMAP_PADDING: float = 8.0

func _ready() -> void:
	Global.minimap = self
	Global.map_generated.connect(draw_minimap)

func draw_minimap() -> void:
	queue_redraw()

func _draw() -> void:
	if Global.main.graph == null:
		print("RETURN")
		return
		
	var graph: RoomGraph = Global.main.graph
	var min_coord: Vector2i = Vector2i(999, 999)
	var max_coord: Vector2i = Vector2i(-999, -999)
	for node in graph.nodes.values():
		node = node as RoomGraph.RoomNode
		min_coord.x = min(min_coord.x, node.coords.x)
		min_coord.y = min(min_coord.y, node.coords.y)
		max_coord.x = max(max_coord.x, node.coords.x)
		max_coord.y = max(max_coord.y, node.coords.y)
	
	var graph_span: Vector2i = max_coord - min_coord + Vector2i(1, 1)
	
	var available: Vector2 = MINIMAP_SIZE - Vector2(MINIMAP_PADDING, MINIMAP_PADDING) * 2.0
	var cell: float = min(available.x / graph_span.x, available.y / graph_span.y)
	var cell_size: Vector2 = Vector2(cell, cell)

	var minimap_origin: Vector2 = Vector2(0, 0)
	var total_size: Vector2 = Vector2(graph_span) * cell_size
	var centering: Vector2 = Vector2((MINIMAP_SIZE.x - total_size.x) / 2.0, (MINIMAP_SIZE.y - total_size.y) / 2.0)
	var offset: Vector2 = minimap_origin + centering
	position.x = 1280 - MINIMAP_SIZE.x - MINIMAP_MARGIN
	position.y = MINIMAP_MARGIN
	print(global_position)
	var outline: float = cell_size.x / 20.0
	draw_rect(Rect2(minimap_origin, MINIMAP_SIZE), Color(0, 0, 0, 0.5), true)
	
	var door_size_factor: float = 10.0
	var door_size: float = cell_size.y / door_size_factor
	for node in graph.nodes.values():
		node = node as RoomGraph.RoomNode
		var pos: Vector2 = offset + Vector2(node.coords - min_coord) * cell_size
		draw_rect(Rect2(pos, cell_size), Global.get_color(node.type), true)
		draw_rect(Rect2(pos, cell_size), Color.WHITE, false, outline)
	
	
	for node in graph.nodes.values():
		
		node = node as RoomGraph.RoomNode
		var center_a: Vector2 = offset + Vector2(node.coords - min_coord) * cell_size + cell_size / 2.0
		for neighbor_id in node.connections:
			var neighbor: RoomGraph.RoomNode = graph.nodes[neighbor_id]
			if neighbor.id < node.id: continue
			var center_b: Vector2 = offset + Vector2(neighbor.coords - min_coord) * cell_size + cell_size / 2.0
			var dir: Vector2 = sign(center_b - center_a)
			var a_frame: Vector2 = center_a + dir * cell_size / 2.0 - dir * outline / 4.0
			var b_frame: Vector2 = center_b - dir * cell_size / 2.0 + dir * outline / 4.0
			draw_line(a_frame + dir.rotated(PI/2) * door_size, a_frame - dir.rotated(PI/2) * door_size, Global.get_color(node.type), outline / 2.0)
			draw_line(b_frame - dir.rotated(PI/2) * door_size, b_frame + dir.rotated(PI/2) * door_size, Global.get_color(neighbor.type), outline / 2.0)
