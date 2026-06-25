extends Node2D

@export var hps = 33.3
@export var time = 20.0

@onready var player = Global.player

func _ready() -> void:
	player.ui.update_health_color(Color(0, 1, 0))
	await get_tree().create_timer(
		time,
		false
	).timeout
	queue_free()
	player.ui.update_health_color(Color(1, 0, 0))

func _process(delta: float) -> void:
	player.heal(hps * delta)
