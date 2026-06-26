extends Projectile


func hit_trigger() -> void:
	Global.player.chips += 5
