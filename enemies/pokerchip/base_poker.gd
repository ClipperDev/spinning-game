extends CharacterBody2D
class_name PokerEnemy

@onready var movement_machine: StateMachine = $movement_machine
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var direction_timer: Timer = $direction_timer

@export var run_speed: float = 300
@export var walk_speed: float = 150
var current_speed: float

@export var gravity: float = 20

@export var max_health: float = 10
var health: float

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


func _on_detection_range_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		alert = true
		pass

func _on_direction_timer_timeout() -> void:
	direction *= -1
	direction_timer.start(randf_range(1.0, 5.0))
	
