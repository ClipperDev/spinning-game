extends CharacterBody2D
class_name Player

@onready var statemachine: Node = $Statemachine
@onready var anim: AnimationPlayer = $AnimationPlayer

const SPEED: float = 300
const JUMP: float = -400

var direction: float = 0
var lookdir: int = 1

func _ready() -> void:
	Global.player = self
	statemachine.get_states(self)

func _process(_delta: float) -> void:
	pass
	
func _physics_process(_delta: float) -> void:
	
	
	
	move_and_slide()
