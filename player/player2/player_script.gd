extends CharacterBody2D
class_name Player

@onready var gun_pivot: Node2D = $body_pivot/gun_pivot
@onready var body_pivot: Node2D = $body_pivot
@onready var head_pivot: Node2D = $body_pivot/head_pivot

@onready var statemachine: Node = $Statemachine
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var gravity: float = 10.0

@export var jump_buffer: float
@export var coyote_time: float
var jump_buffer_timer: float
var coyote_timer: float

@export var speed: float = 150.0
@export var jump: float = 300.0

var lookdir: int = 1
var can_jump: bool

func _ready() -> void:
	Global.player = self
	statemachine.initialize(self, &"idle")

func _process(_delta: float) -> void:
	pass
	
func _physics_process(_delta: float) -> void:
	#LOOKDIR 
	if get_global_mouse_position().x >= global_position.x:
		lookdir = 1
	elif get_global_mouse_position().x < global_position.x:
		lookdir = -1
	
	rotate_head()
	rotate_gun()
	
	
	move_and_slide()

func rotate_gun() -> void:
	gun_pivot.look_at(get_global_mouse_position())
	#if gun_pivot.rotation > PI * 3 / 2 or gun_pivot.rotation < -PI * 3 / 2:
		#gun_pivot.rotation = 0
	#if gun_pivot.rotation > PI / 2 or gun_pivot.rotation < -PI / 2:
		#lookdir = -1
	#else:
		#lookdir = 1
func rotate_head():
	head_pivot.look_at(get_global_mouse_position())
	head_pivot.rotation = clampf(head_pivot.rotation, deg_to_rad(-20), deg_to_rad(50))

	
func change_anim(anim: String) -> void:
	if !(animation_player.has_animation(anim) or animation_player.current_animation == anim):
		return
		
	animation_player.play(anim)
	
