extends WheelEffect

@onready var effect = preload("res://wheel_slots/effects_to_bullets/long_shot_bullet_effect.tscn")

func bullet_on_shot_specials(bullet: Projectile) -> void:
	var e = effect.instantiate()
	bullet.add_child(e)
