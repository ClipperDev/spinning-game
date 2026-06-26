@tool
extends Node
## Handles Caching and Access of Rooms
## A Resource containing all the paths to rooms, with their respective ID's in a dictionary
const REGISTRY: RoomsPaths = preload("res://room_management/registry.tres")


## Rooms currently queued to be loaded and added to [room_cache]
var pending: Dictionary[StringName, bool] = {}
var room_cache: Dictionary[StringName, PackedScene] = {}
signal room_loaded(id: StringName)

func _ready() -> void:
	
	assert(REGISTRY != null and REGISTRY.ROOM_PATHS.size() > 0, "INVALID ROOM REGISTRY!")
	

func _process(delta: float) -> void:
	
	if pending.is_empty():
		set_process(false)
	
	for room_id in pending.keys():
		var status = get_room_status(room_id)
	
		match status:
			ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
				room_cache[room_id] = ResourceLoader.load_threaded_get(REGISTRY.ROOM_PATHS[room_id])
				pending.erase(room_id)
				room_loaded.emit(room_id)
				print_rich("[color=green]LOADED ", room_id)
				
			ResourceLoader.ThreadLoadStatus.THREAD_LOAD_FAILED:
				push_error("COULD NOT LOAD ROOM -> ", room_id)
				pending.erase(room_id)
				
## Returns the cached room with the specific room_id, requests its load and wait until its loaded. Is a couroutine
func get_packed_room(room_id: StringName) -> PackedScene:
	if not REGISTRY.ROOM_PATHS.has(room_id):
		push_error("INVALID ROOM ID: ", room_id)
		return null
		
	if room_cache.has(room_id):
		return room_cache[room_id]
	if not pending.has(room_id):
		request_room_load(room_id)
	
	while not room_cache.has(room_id):
		await room_loaded
	
	return room_cache[room_id]

## Gets the load status of a room
func get_room_status(room_id: StringName) -> ResourceLoader.ThreadLoadStatus:
	return ResourceLoader.load_threaded_get_status(REGISTRY.ROOM_PATHS[room_id])

## Requests loading of a specific room from [REGISTRY]
func request_room_load(room_id: String) -> void:
	if room_cache.has(room_id) or pending.has(room_id):
		return
	if not REGISTRY.ROOM_PATHS.has(room_id):
		push_error("INVALID ROOM ID: ", room_id)
		return
	
	
	assert(ResourceLoader.exists(REGISTRY.ROOM_PATHS[room_id], "PackedScene"), \
	"ROOM DOES NOT EXIST , room_id -> " + str(room_id) + " path -> " + REGISTRY.ROOM_PATHS[room_id])
	
	ResourceLoader.load_threaded_request(REGISTRY.ROOM_PATHS[room_id], "PackedScene")
	pending[room_id] = true
	set_process(true)

## Updates the [room_cache], keeping only the specified room_id's, add them if they aren't already on it
func update_cache(keep: Dictionary[StringName, bool]) -> void:
	
	for room_id in room_cache.keys():
		if not keep.has(room_id):
			room_cache.erase(room_id)
			print_rich("[color=red]ERASED ", room_id)
			continue
		keep.erase(room_id)
		
	for room_id in keep.keys():
		request_room_load(room_id)

func pick_room(type: RoomGraph.RoomType, 
required_doors: Array[RoomData.DoorDir], 
rng: RandomNumberGenerator) -> StringName:
	var candidates: Array[StringName] = []
	
	for id in REGISTRY.ROOM_DATA.keys():
		var data: RoomData = REGISTRY.ROOM_DATA[id]
		if data.type != type:
			continue
		if not _has_required_doors(data.doors, required_doors):
			continue
		candidates.append(id)
	
	assert(not candidates.is_empty(), "NO VALID DOORS FOUND " + str(type) + " " + str(required_doors))
	return candidates[rng.randi_range(0, candidates.size() - 1)]
		
func _has_required_doors(available: Array[RoomData.DoorDir], required: Array[RoomData.DoorDir]) -> bool:
	var a: Array[RoomData.DoorDir] = available.duplicate()
	var r: Array[RoomData.DoorDir] = required.duplicate()
	a.sort()
	r.sort()
	return a == r
