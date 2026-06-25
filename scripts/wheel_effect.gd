class_name WheelEffect
extends Node2D
## add under the gun node

@export var ammo_mod: int #flat
@export var fire_rate_mod = 0.0 #flat
@export var reload_speed_mod = 0.0 #flat
@export var damage_mod = 1.0 #multiplicative
@export var bullet_vel_mod = 1.0 #multiplicative
@export var bullet_size_mod = 1.0 #multiplicative

@onready var player = $"../.."

func _ready() -> void:
	on_roll_specials()
	activate()

## runs on spawn
func activate() -> void:
	get_parent().ammo += ammo_mod
	get_parent().fire_rate += fire_rate_mod
	get_parent().reload_speed -= reload_speed_mod
	activate_specials()

## overridable
func activate_specials() -> void:
	pass

## runs on deletion
func deactivate() -> void:
	get_parent().fire_rate -= fire_rate_mod
	get_parent().reload_speed += reload_speed_mod
	deactivate_specials()
	queue_free()

## overridable
func deactivate_specials() -> void:
	pass

## overridable. only for one time on-roll effects
func on_roll_specials() -> void:
	pass

## main func for applying stats to bullets, triggered via gun operator
func bullet_on_shot_effect(bullet: Projectile) -> void:
	bullet.damage *= damage_mod
	bullet.get_child(0).shape.radius *= bullet_size_mod
	bullet.speed *= bullet_vel_mod
	bullet_on_shot_specials(bullet)

## overridable. for effects that trigger on shooting 
func bullet_on_shot_specials(bullet: Projectile) -> void:
	pass
