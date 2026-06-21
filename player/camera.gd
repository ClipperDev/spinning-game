extends Camera2D

@export var shake_fade: float = 10.0

var player_favor: float = 20

var _shake: float = 0

func _ready() -> void:
	Global.camera = self

func _physics_process(_delta: float) -> void:
	var path: Vector2 = -Global.player.global_position + get_global_mouse_position()
	global_position = (Global.player.global_position + (path * player_favor/100))
	
func _process(delta: float) -> void:
	if _shake > 0:
		_shake = lerp(_shake, 0.0, shake_fade * delta)
	offset = Vector2(randf_range(-_shake, _shake), randf_range(-_shake, _shake))

func shake(shake_strength: float):
	_shake = shake_strength
