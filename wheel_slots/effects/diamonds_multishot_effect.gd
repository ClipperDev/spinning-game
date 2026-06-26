extends WheelEffect


func bullet_on_shot_specials(_bullet: Projectile) -> void:
	for i in 3:
		var bul = get_parent().fire_bullet()
		bul.rotation += randf_range(-0.062, 0.062)
		
	#player.velocity.x -= cos(player.gun_pivot.rotation * 1500)
	#player.velocity.y -= sin(player.gun_pivot.rotation * 1500)
