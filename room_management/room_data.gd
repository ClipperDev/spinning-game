class_name RoomData extends Resource

enum DoorDir {LEFT, RIGHT, TOP, BOTTOM}
@export var id: StringName
@export var floor_id: int
@export var doors: Array[DoorDir] = []:
	set(value):
		print(value)
		doors = value
