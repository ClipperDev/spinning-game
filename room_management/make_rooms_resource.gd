@tool
extends EditorScript

var registry_path: String = "res://room_management/registry.tres"
var rooms_dir_path: String = "res://room_management/rooms/"

func _run() -> void:
	var room_paths: RoomsPaths = RoomsPaths.new()
	var files: PackedStringArray = DirAccess.get_files_at(rooms_dir_path)
	
	for file in files:
		if file.get_extension() == "tscn":
			var path: String = rooms_dir_path + file
			var scene: PackedScene = load(path)
			var room: Room = scene.instantiate()
			
			assert(room.room_data != null, "NULL ROOM DATA " + path)
			var id: StringName = room.room_data.id
			room_paths.ROOM_PATHS[id] = path
			room_paths.ROOM_DATA[id] = room.room_data
			
			room.free()
			
	printerr(ResourceSaver.save(room_paths, registry_path))

	print_rich("[color=green][b] MADE ROOM REGISTRY, FOUND: [color=white]", room_paths.ROOM_PATHS.size(), " ROOMS.")
