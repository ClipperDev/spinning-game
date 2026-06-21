extends CharacterBody2D

@onready var ui = $ui
@onready var gun_pivot: Node2D = $gun_pivot
@onready var body_pivot: Node2D = $body_pivot
@onready var head_pivot: Node2D = $body_pivot/head_pivot

@export var max_hp: float = 100.0
var hp: float = max_hp
@export var max_ammo: int = 6
var ammo: int = max_ammo
@export var speed: float = 300.0
@export var jump_vel: float = 400.0
@export var acceleration: float
@export var air_control: float
@export var dash_str: float
@export var default_bullet: WheelSlot 
@export var normal_slots: Array[WheelSlot]
@export var jackpot_slot: WheelSlot
@export var current_slot: WheelSlot

var chips = 100

var gun_flipped = false

func _process(_delta: float) -> void:
	rotate_gun()
	rotate_head()
	body_flipper()
	
func _physics_process(delta: float) -> void:
	# onle the basic movement is in play rn, maybe change this later
	if not is_on_floor():
		velocity += get_gravity() * 0.9 * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_vel
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	move_and_slide()

func rotate_gun() -> void:
	gun_pivot.look_at(get_global_mouse_position())
	if gun_pivot.rotation > PI * 3 / 2 or gun_pivot.rotation < -PI * 3 / 2:
		gun_pivot.rotation = 0
	if gun_pivot.rotation > PI / 2 or gun_pivot.rotation < -PI / 2:
		if not gun_flipped:
			gun_flipped = true
			gun_pivot.scale.y = abs(gun_pivot.scale.y) * -1
			#gun_pivot.get_node("gun_sprite").set_flip_v(true)
	else:
		if gun_flipped:
			gun_flipped = false
			gun_pivot.scale.y = abs(gun_pivot.scale.y)
			#gun_pivot.get_node("gun_sprite").set_flip_v(false)

func rotate_head():
	head_pivot.look_at(get_global_mouse_position())
	#if head_pivot.rotation > PI * 3 / 2 or head_pivot.rotation < -PI * 3 / 2:
		#head_pivot.rotation = 0
	#if head_pivot.rotation > PI / 2 or head_pivot.rotation < -PI / 2:
	#if not gun_flipped:
		#head_pivot.scale.y = abs(head_pivot.scale.y)
	#elif gun_flipped:
			#head_pivot.scale.y = abs(head_pivot.scale.y) * -1

func body_flipper():
	if gun_flipped:
		body_pivot.scale.x = abs(body_pivot.scale.x) * -1
	elif not gun_flipped:
		body_pivot.scale.x = abs(body_pivot.scale.x)


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
		randomize()
		var rng = randf_range(0.0, 1.0)
		if rng <= 0.04:
			current_slot = jackpot_slot
		else:
			current_slot = normal_slots.pick_random()
		ammo = max_ammo
	

func shoot() -> void:
	if ammo > 0:
		var bullet: Area2D = current_slot.bullet.instantiate()
		add_sibling(bullet)
		bullet.global_transform = gun_pivot.get_node("muzzle").global_transform
		ammo -= 1
	

# replace a section with a new one
func replace_wheel_section(section: WheelSlot, slot: int, jackpot: float = false) -> void:
	if jackpot:
		jackpot_slot = section
	else:
		normal_slots[slot] = section
	# animations needed
