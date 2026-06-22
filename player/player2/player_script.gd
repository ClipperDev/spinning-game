extends CharacterBody2D
class_name Player

@onready var gun_pivot: Node2D = $gun_pivot
@onready var body_pivot: Node2D = $body_pivot
@onready var head_pivot: Node2D = $body_pivot/head_pivot

@onready var statemachine: Node = $Statemachine
@onready var anim: AnimationPlayer = $AnimationPlayer

const SPEED: float = 300
const JUMP: float = 500

var direction: float = 0
var lookdir: int = 1

func _ready() -> void:
	Global.player = self
	statemachine.get_states(self)

func _process(_delta: float) -> void:
	pass
	
func _physics_process(_delta: float) -> void:
	rotate_head()
	rotate_gun()
	body_flipper()
	
	move_and_slide()

func rotate_gun() -> void:
	gun_pivot.look_at(get_global_mouse_position())
	if gun_pivot.rotation > PI * 3 / 2 or gun_pivot.rotation < -PI * 3 / 2:
		gun_pivot.rotation = 0
	if gun_pivot.rotation > PI / 2 or gun_pivot.rotation < -PI / 2:
		lookdir = -1
		gun_pivot.scale.y = abs(gun_pivot.scale.y) * -1
	else:
		lookdir = 1
		gun_pivot.scale.y = abs(gun_pivot.scale.y)
		
func rotate_head():
	head_pivot.look_at(get_global_mouse_position())
	head_pivot.rotation = clampf(head_pivot.rotation, deg_to_rad(-20), deg_to_rad(50))

func body_flipper():
	body_pivot.scale.x = abs(body_pivot.scale.x) * lookdir
	
