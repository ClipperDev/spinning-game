@tool
extends Node
## Manages all room creation behaviour
const FLOORPROTO = preload("uid://b6s4v38ev463e")

var map_rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	map_rng.randomize()
	print(map_rng.seed)

## Current generated room room
var current_room: Room

func generate_map() -> void:
	if Global.current_floor:
		Global.current_floor.queue_free()
	Global.player.process_mode = Node.PROCESS_MODE_DISABLED
	Global.player.set_process(false)
	Global.player.set_physics_process(false)
	var new_floor: Node2D = Node2D.new()
	Global.main.add_child(new_floor)
	Global.current_floor = new_floor
	
	var starting_room = await RoomRegistry.get_packed_room(FLOORPROTO.starting_room_id)
	current_room = starting_room.instantiate()
	Global.current_floor.add_child(current_room)
	var remaining_rooms: Array[Room] = [current_room]
	
	while !remaining_rooms.is_empty():
		for room in remaining_rooms:
			remaining_rooms.append_array(await generate_rooms(room))
			remaining_rooms.erase(room)
	Global.player.process_mode = Node.PROCESS_MODE_INHERIT
	Global.player.set_process(true)
	Global.player.set_physics_process(true)
	
func generate_rooms(room: Room) -> Array[Room]:
	
	var generated_rooms: Array[Room] = []
	
	for door in room.doors.keys():
		if room.doors[door].door_id == room.enterance:
			continue
		var next_room: RoomChoice = room.doors[door].possible_rooms[map_rng.randi_range(0, room.doors[door].possible_rooms.size() - 1)]
		var room_scene: PackedScene = await RoomRegistry.get_packed_room(next_room.room_id)
		current_room = room_scene.instantiate()
		current_room.enterance = next_room.door_index
		
		Global.current_floor.add_child(current_room)
		current_room.global_position = room.doors[door].global_position + \
		(current_room.global_position - current_room.doors[next_room.door_index].global_position)
		generated_rooms.append(current_room)
	return generated_rooms
