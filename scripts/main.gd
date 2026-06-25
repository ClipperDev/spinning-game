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
	graph = map_gen.generate_graph(rng, FLOORPROTO)
	queue_redraw()

func get_color(type: RoomGraph.RoomType) -> Color:
	match type:
		RoomGraph.RoomType.START:
			return Color(0, 0, 1)
		RoomGraph.RoomType.BOSS:
			return Color(1, 0, 0)
		RoomGraph.RoomType.REST:
			return Color(0, 1, 0)
	return Color(1, 1, 0)

func _draw() -> void:
	
	
	for node in graph.nodes.values():
		node = node as RoomGraph.RoomNode
		var pos_a: Vector2 = Vector2(node.coords.x * 1280/10.0, node.coords.y * 720/10.0)
		var size_a: Vector2 = Vector2(1280, 720) / 10.0
		draw_rect(Rect2(pos_a, size_a), get_color(node.type), true)
		draw_rect(Rect2(pos_a, size_a), Color.WHITE, false, 4)
