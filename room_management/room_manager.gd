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
	pass
