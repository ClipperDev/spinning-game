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

@onready var wheel = $wheel_components
@onready var ray =  $ray

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


func replace_visual_slot(new_section: WheelSlot, slot: int) -> void:
	wheel.get_child(slot + 1).texture = new_section.wheel_texture
	
