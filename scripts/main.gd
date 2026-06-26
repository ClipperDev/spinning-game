@tool
class_name Main extends Control
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

const PLAYER = preload("uid://c5coxd37o8782")
@export_tool_button("Generate Map")
var map: Callable = regen_map

const FLOORPROTO = preload("uid://b6s4v38ev463e")
var map_gen: MapGenerator = MapGenerator.new()
var graph: RoomGraph = map_gen.generate_graph(rng, FLOORPROTO)
func _ready() -> void:
	regen_map()
	return
	Global.main = self
	print()
	Global.player = PLAYER.instantiate()
	RoomManager.generate_map()
	Global.player.global_position = Vector2(200, 200)
	add_child(Global.player)
	
	
	Global.camera = PlayerCamera.new()
	add_child(Global.camera)

func regen_map() -> void:
	rng.randomize()
	graph = map_gen.generate_graph(rng, FLOORPROTO)
	if graph == null:
		return
	queue_redraw()

func get_color(type: RoomGraph.RoomType) -> Color:
	match type:
		RoomGraph.RoomType.START:
			return Color(0, 0, 1)
		RoomGraph.RoomType.BOSS:
			return Color(1, 0, 0)
		RoomGraph.RoomType.REST:
			return Color(0, 1, 0)
		RoomGraph.RoomType.SHOP:
			return Color(0.7, 0.1, 0.4)
		
	return Color(0.4, 0.4, 0.4)

func _draw() -> void:
	if graph == null:
		return
	var cell_size: Vector2 = Vector2(1280, 720) / 1.0
	var outline: float = cell_size.x/20.0
	var door_size_factor: float = 10.0
	var door_size: float = cell_size.y / door_size_factor
	for node in graph.nodes.values():
		node = node as RoomGraph.RoomNode
		var pos: Vector2 = Vector2(node.coords.x * cell_size.x, node.coords.y * cell_size.y)
		draw_rect(Rect2(pos, cell_size), get_color(node.type), true)
		draw_rect(Rect2(pos, cell_size), Color.WHITE, false, outline)
	
	
	for node in graph.nodes.values():
		
		node = node as RoomGraph.RoomNode
		var center_a: Vector2 = Vector2(node.coords.x * cell_size.x, node.coords.y * cell_size.y) + cell_size / 2.0
		for neighbor_id in node.connections:
			var neighbor: RoomGraph.RoomNode = graph.nodes[neighbor_id]
			if neighbor.id < node.id: continue
			var center_b: Vector2 = Vector2(neighbor.coords.x * cell_size.x, neighbor.coords.y * cell_size.y) + cell_size / 2.0
			var dir: Vector2 = sign(center_b - center_a)
			var a_frame: Vector2 = center_a + dir * cell_size / 2.0 - dir * outline / 4.0
			var b_frame: Vector2 = center_b - dir * cell_size / 2.0 + dir * outline / 4.0
			draw_line(a_frame + dir.rotated(PI/2) * door_size, a_frame - dir.rotated(PI/2) * door_size, get_color(node.type), outline / 2.0)
			draw_line(b_frame - dir.rotated(PI/2) * door_size, b_frame + dir.rotated(PI/2) * door_size, get_color(neighbor.type), outline / 2.0)
