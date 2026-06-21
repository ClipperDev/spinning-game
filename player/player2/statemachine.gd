extends Node

@export var initial_state: State

var current_state: State
var all_states: Dictionary = {}

func _ready() -> void:
	pass

func get_states(_handled_node):
	for child in get_children():
		if child is State:
			all_states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)
			child.Set_handled_node(_handled_node)
		

	if initial_state:
		initial_state.Enter()
		current_state = initial_state

func _process(delta: float) -> void:
	if current_state:
		current_state.Process(delta)
		
func _physics_process(delta: float) -> void:
	if current_state:
		current_state.Physics_Process(delta)


func on_child_transition(state, new_state_name):
	if state != current_state:
		return
	
	var new_state = all_states.get(new_state_name.to_lower())
	if !new_state:
		return
		
	if current_state:
		current_state.Exit()
		
	new_state.Enter()
	
	current_state = new_state
