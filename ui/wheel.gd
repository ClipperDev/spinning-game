extends Control

signal spin_result(section: int)

@export var spin_speed: float = 180
@export var base_spin_time: float = 1.2

enum steps {
	ACCEL,
	SPINNING,
	WINDDOWN,
	INACTIVE
}

var step = steps.INACTIVE
var spin_time_left: float
var spin_vel: float

var replacing_sections = false
var stored_wheel_for_replace: WheelSlot

@onready var wheel = $wheel_components
@onready var ray =  $ray
@onready var replace_buttons = $wheel_components/replace_buttons

func _ready() -> void:
	for i in replace_buttons.get_children():
		i.button_down.connect(replace)

func spin() -> void:
	step = steps.ACCEL
	spin_time_left = base_spin_time + randf_range(-0.3, 0.3)

func _process(delta: float) -> void:
	#don't do anythig if inactive
	if step == steps.INACTIVE: return
	
	match step:
		steps.ACCEL:
			spin_vel += deg_to_rad(spin_speed * delta)
			if spin_vel >= deg_to_rad(spin_speed):
				step = steps.SPINNING
			
		steps.SPINNING:
			spin_time_left -= delta
			if spin_time_left <= 0:
				step = steps.WINDDOWN
			
		steps.WINDDOWN:
			spin_vel -= deg_to_rad(spin_speed * delta)
			if spin_vel <= 0:
				determine_result()
	#print(step)
	wheel.rotate(spin_vel)

func determine_result() -> int:
	ray.enabled = true
	await get_tree().physics_frame
	await get_tree().physics_frame
	var slot_id: int = (ray.get_collider().name.right(1)).to_int() - 1
	spin_result.emit(slot_id)
	step = steps.INACTIVE
	ray.enabled = false
	
	return slot_id

func start_replacing(wheel_slot: WheelSlot) -> void:
	stored_wheel_for_replace = wheel_slot
	replacing_sections = true
	replace_buttons.show()
	Global.player.ui.anim_player.play("wheel_down")

func stop_replacing() -> void:
	stored_wheel_for_replace = null
	replacing_sections = false
	replace_buttons.hide()
	Global.player.ui.anim_player.play("wheel_up")

func replace() -> void:
	if replacing_sections != true: return
	for i in replace_buttons.get_children():
		if i.button_pressed:
			var slot = i.get_index()
			Global.player.get_node("gun_operator").replace_wheel_section(stored_wheel_for_replace, slot)
			replace_visual_slot(stored_wheel_for_replace, slot)
			stop_replacing() 


func replace_visual_slot(new_section: WheelSlot, slot: int) -> void:
	wheel.get_child(slot + 1).texture = new_section.wheel_texture
	
