extends Control

@onready var wheel = $CanvasLayer/wheel
@onready var hp_bar = $CanvasLayer/hp_bar
@onready var chips = $CanvasLayer/chips
@onready var anim_player = $CanvasLayer/AnimationPlayer
@onready var player = Global.player

var new_hp = 100.0
var new_color: Color = Color(1, 0, 0)


func _process(delta: float) -> void:
	chips.text = str(int(lerp(chips.text.to_int(), player.chips, 0.2)))
	hp_bar.value = lerp(hp_bar.value, new_hp, 5.0 * delta)
	hp_bar.tint_progress = lerp(hp_bar.tint_progress, new_color, 5.0 * delta)

#should update the wheel when called
func update_slots_icons(slot: WheelSlot, id: int) -> void:
	wheel.replace_visual_slot(slot, id)


func update_health(value) -> void:
	new_hp = value

func update_health_color(color: Color) -> void:
	new_color = color
	
