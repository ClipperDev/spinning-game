extends Node2D

@export var max_ammo: float 
var ammo = max_ammo
@export var reload_speed: float
@export var fire_rate: float

@export var default_bullet: WheelSlot
@export var normal_slots: Array[WheelSlot]
@export var jackpot_slot: WheelSlot
@export var current_slot: WheelSlot

var damage_mod = 1.0
var bullet_vel_mod = 1.0
var bullet_size_mod = 1.0

var lifesteal = 0.0

@onready var player = get_parent()
@onready var muzzle = $"../body_pivot/gun_pivot/muzzle"

func _input(event: InputEvent) -> void:
	# shooting
	if event.is_action_pressed("fire"):
		shoot()
	# reloading. add animation later
	if event.is_action_pressed("reload"):
		await get_tree().create_timer(
			1.44,
			false
		).timeout
		ammo = max_ammo
		current_slot = default_bullet
	
	# spin to win type shi, add animations later
	if event.is_action_pressed("spin"):
		print("spin")
		player.get_node("ui").wheel.spin()
		player.get_node("ui").wheel.spin_result.connect(spin_result)


func spin_result(id: int) -> void:
	if id == 7:
		current_slot = jackpot_slot
	else:
		current_slot = normal_slots[id]
	ammo = max_ammo
	print(id)

func shoot() -> void:
	fire_bullet()

func fire_bullet() -> void:
	if ammo > 0:
		var bullet: Area2D = current_slot.bullet.instantiate()
		player.add_sibling(bullet)
		bullet.global_transform = muzzle.global_transform
		ammo -= 1


# replace a wheel section with a new one
func replace_wheel_section(section: WheelSlot, slot: int, jackpot: float = false) -> void:
	if jackpot:
		jackpot_slot = section
	else:
		normal_slots[slot] = section
	# animations needed
