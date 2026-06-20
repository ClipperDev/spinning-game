extends CharacterBody2D

@onready var gun_pivot = $gun_pivot
@onready var ui = $ui

@export var max_hp: float = 100.0
var hp: float = max_hp
@export var max_ammo: int = 6
var ammo: int
@export var speed: float = 300.0
@export var jump_vel: float = 400.0
@export var normal_slots: Array[WheelSlot]
@export var jackpot_slot: WheelSlot
@export var current_slot: WheelSlot

var gun_flipped = false

func _process(delta: float) -> void:
	rotate_gun()

func _physics_process(delta: float) -> void:
	# onle the basic movement is in play rn, maybe change this later
	if not is_on_floor():
		velocity += get_gravity() * delta
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
			gun_pivot.get_node("gun_sprite").set_flip_v(true)
	else:
		if gun_flipped:
			gun_flipped = false
			gun_pivot.get_node("gun_sprite").set_flip_v(false)


func _input(event: InputEvent) -> void:
	# shooting
	if event.is_action_pressed("fire"):
		var bullet: Area2D = current_slot.bullet.instantiate()
		add_sibling(bullet)
		bullet.global_transform = gun_pivot.get_node("muzzle").global_transform
	
	# spin to win type shi, add animations later
	if event.is_action_pressed("spin"):
		randomize()
		current_slot = normal_slots.pick_random()
	

func update_slots_icons() -> void:
	pass
