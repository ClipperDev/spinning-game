extends CharacterBody2D
class_name PokerEnemy

@onready var movement_machine: StateMachine = $movement_machine
@onready var animated_sprite_2d: AnimatedSprite2D = $body/AnimatedSprite2D
@onready var direction_timer: Timer = $direction_timer
@onready var aggro_timer: Timer = $aggro_timer
@onready var body: Node2D = $body

@onready var leftcast: RayCast2D = $left
@onready var rightcast: RayCast2D = $right

@export var run_speed: float = 300
@export var walk_speed: float = 150
var current_speed: float

@export var gravity: float = 20

@export var max_health: float = 10
var health: float
@export var damage: float = 10

var alert: bool = false

var direction: float = 1.0

func _ready() -> void:
	direction = [-1.0, 1.0].pick_random()
	health = max_health
	movement_machine.initialize(self, &"walk")


func _process(_delta: float) -> void:
	if alert == true:
		current_speed = run_speed
	else: current_speed = walk_speed
	

func _physics_process(_delta: float) -> void:
	if leftcast.is_colliding():
		var collider = leftcast.get_collider()
		if collider.is_in_group("player"):
			alert = true
	if rightcast.is_colliding():
		var collider = rightcast.get_collider()
		if collider.is_in_group("player"):
			alert = true

	

func _on_direction_timer_timeout() -> void:
	direction *= -1
	direction_timer.start(randf_range(3.0, 7.0))
	
func take_damage(value: float):
	health -= value
