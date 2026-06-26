class_name Main extends Control
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

const PLAYER = preload("uid://c5coxd37o8782")
@onready var world_tile_map: TileMapLayer = $WorldTileMap


const FLOORPROTO = preload("uid://b6s4v38ev463e")
var map_gen: MapGenerator = MapGenerator.new()
var graph: RoomGraph = map_gen.generate_graph(rng, FLOORPROTO)
func _ready() -> void:
	Global.main = self
	await place_rooms(graph, world_tile_map)
	Global.map_generated.emit()
	Global.player = PLAYER.instantiate()
	Global.player.global_position = Vector2(200, 200)
	add_child(Global.player)
	Global.camera = PlayerCamera.new()
	add_child(Global.camera)

func regen_map() -> void:
	rng.randomize()
	graph = map_gen.generate_graph(rng, FLOORPROTO)
	if graph == null:
		return

func place_rooms(_graph: RoomGraph, final_tilemap: TileMapLayer) -> void:

	for node in _graph.nodes.values():
		node = node as RoomGraph.RoomNode
		var scene: PackedScene = await RoomRegistry.get_packed_room(node.scene_id)
		var room: Room = scene.instantiate()
		var tile_map_layer: TileMapLayer = room.get_node("TileMapLayer")
		print(node.scene_id)
		var world_pos: Vector2 = Vector2(node.coords) * Global.room_size
		var world_coord: Vector2i = Vector2i(world_pos) / Vector2i(96, 96)
		node.world_pos = world_pos
		var new_tilemap_cells = tile_map_layer.get_used_cells().map(func(s): return s + world_coord)
		final_tilemap.set_cells_terrain_connect(new_tilemap_cells, 0, 0)
		tile_map_layer.queue_free()
		add_child(room)
		room.global_position = world_pos
	
	final_tilemap.update_internals()
	RoomRegistry.room_cache.clear()
