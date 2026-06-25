extends Node2D

@export var max_ammo: int = 9
var ammo: int = max_ammo
@export var reload_speed: float = 1.44
@export var fire_rate: float = 2.5
@export var spin_cost: int = 25

@export var default_bullet: WheelSlot
@export var normal_slots: Array[WheelSlot]
@export var jackpot_slot: WheelSlot
@export var current_slot: WheelSlot

@export var damage_mod = 1.0
@export var bullet_vel_mod = 1.0
@export var bullet_size_mod = 1.0

# tied to fire rate, can only shoot if it's recharged
var shot_charged = false
# to not overlap multiple reloads
var reloading = false
# to not overlap multiple spins
var spinning = false

@onready var player = get_parent()
@onready var muzzle = $"../body_pivot/gun_pivot/muzzle"

func _input(event: InputEvent) -> void:
	# shooting
	if event.is_action_pressed("fire"):
		if shot_charged == true:
			shoot()
	# reloading. add animation later
	if event.is_action_pressed("reload"):
		if not reloading:
			reloading = true
			await get_tree().create_timer(
				reload_speed,
				false
			).timeout
			reload()
	
	# spin to win type shi, add animations later
	if event.is_action_pressed("spin"):
		if spinning: return
		if player.chips < spin_cost:
			# do feedback
			return
		player.chips -= spin_cost
		spinning = true
		player.get_node("ui").wheel.spin()
		if not player.get_node("ui").wheel.is_connected('spin_result', spin_result):
			player.get_node("ui").wheel.spin_result.connect(spin_result)

# clear previous wheel effect, add a new one
func spin_result(id: int) -> void:
	reload()
	if id == 7:
		current_slot = jackpot_slot
	else:
		current_slot = normal_slots[id]
	var wheel_effect = current_slot.effects.instantiate()
	add_child(wheel_effect)
	spinning = false

func reload() -> void:
	ammo = max_ammo
	current_slot = default_bullet
	if get_child(0) != null:
		get_child(0).deactivate()
	reloading = false

#fire bullet, then wait for 1 / fire rate before shooting again
func shoot() -> void:
	fire_bullet()
	shot_charged = false
	await get_tree().create_timer(
		1.0 / fire_rate,
		false
	).timeout
	shot_charged = true


func fire_bullet() -> void:
	if ammo > 0:
		var bullet: Projectile = current_slot.bullet.instantiate()
		player.add_sibling(bullet)
		bullet.global_transform = muzzle.global_transform
		bullet.damage *= damage_mod
		bullet.get_child(0).shape.radius *= bullet_size_mod
		bullet.speed *= bullet_vel_mod
		if get_child(0) != null:
			get_child(0).bullet_on_shot_effect(bullet)
		ammo -= 1


# replace a wheel section with a new one
func replace_wheel_section(section: WheelSlot, slot: int, jackpot: bool = false) -> void:
	if jackpot:
		jackpot_slot = section
	else:
		normal_slots[slot] = section
		
