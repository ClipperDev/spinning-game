extends GPUParticles2D


func _ready() -> void:
	await get_tree().create_timer(
		1,
		false
	).timeout
	queue_free()
