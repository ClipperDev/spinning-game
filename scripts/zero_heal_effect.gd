extends Node2D

@export var hps = 33.3
@export var time = 20.0

@onready var player = Global.player

func _ready() -> void:
	await get_tree().create_timer(
		time,
		false
	).timeout
	queue_free()

func _process(delta: float) -> void:
	player.heal(hps * delta)
