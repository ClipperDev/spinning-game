extends Node
class_name StateMachine

@export var debug: bool = false

var states: Dictionary[StringName, BaseState] = {}
var transitioning: bool = false

# State management
var default_state_name: StringName
var current_state: BaseState
var current_state_name: StringName
var prev_state_name: StringName

signal state_changed(state: StringName)

func _ready() -> void:
	#Disables process until initialize is called
	process_mode = Node.PROCESS_MODE_DISABLED


func _process(delta: float) -> void:
	if current_state:
		request_transition(current_state.process_state(delta))


func _physics_process(delta: float) -> void:
	if current_state:
		request_transition(current_state.physics_state(delta))


func _unhandled_input(event: InputEvent) -> void:
	if current_state:
		request_transition(current_state.handle_input_state(event))


# First initialisation of statemachine, based on children
func initialize(_handled_node: Node, _default_state: StringName = "") -> void:
	states.clear()

	# Adds every valid child as a state, and sets its owner
	for child in get_children():
		if child is BaseState:
			if child.id.is_empty():
				continue
			states[child.id] = child
			child.set_handled_node(_handled_node)
			child.state_machine = self

	if states.size() == 0:
		push_error("StateMachine: No States found for: ", _handled_node.name, " Machine: ", name)
		return

	default_state_name = _default_state

	# Checks for a default state, fall backs to first index in array, if none, or invalid
	if default_state_name.is_empty() or !states.has(default_state_name):
		push_warning("Default state -> " + default_state_name + \
		 " invalid for: " + _handled_node.name + ". Switching to first state")
		default_state_name = states.keys()[0]

	# Starts the process
	process_mode = Node.PROCESS_MODE_INHERIT
	transitioning = false
	change_state(default_state_name)

func request_transition(state_name: StringName, data: Variant = null) -> void:
	if state_name.is_empty():
		return
	
	if !states.has(state_name):
		if debug:
			print_rich("[color=red][b]Invalid State Change from: [/b][/color]", "[color=green]", current_state_name, "[/color] -> [color=red] ", state_name, "[/color]")
		return
	
	change_state(state_name, data)

func change_state(_state_name: StringName, data: Variant = null) -> void:
	if transitioning: # checker if change_state has not exited
		return

	# Stays same, if state is same
	if _state_name == current_state_name and data == null:
		return

	transitioning = true
	
	var next_state: BaseState = states[_state_name]
	
	if next_state and !next_state.can_enter():
		transitioning = false
		return
	
	var old_state: BaseState = current_state
	current_state = null
	
	# Checks if old state can exit
	if old_state and !old_state.can_exit():
		current_state = old_state
		transitioning = false
		return

	# Exits old state
	if old_state:
		old_state.exit()

	prev_state_name = current_state_name
	current_state_name = _state_name
	current_state = next_state

	#Start current state
	current_state.enter(data)
	transitioning = false
	
	if debug:
		print_rich("[color=yellow][b]State Changed [/b][/color]: ", "[color=green]" ,prev_state_name, "[/color] -> [color=green]", current_state_name, "[/color]")

	state_changed.emit(current_state_name)
