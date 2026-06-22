extends Node
class_name BaseState

const NO_STATE: StringName = StringName()
var handled_node: Node = null
var state_machine: StateMachine = null
@export var id : StringName

func _ready() -> void:
	assert(!id.is_empty(), "State has empty id: " + name)

func enter(_data: Variant) -> void:
	return
 
func exit() -> void:
	return
	
func process_state(_delta: float) -> StringName:
	return NO_STATE

func physics_state(_delta: float) -> StringName:
	return NO_STATE
	
func handle_input_state(_event: InputEvent) -> StringName:
	return NO_STATE

func can_exit() -> bool:
	return true

func can_enter() -> bool:
	return true

func transition_to(state: StringName, data: Variant = null) -> void:
	state_machine.request_transition(state, data)

# Sets the handled node for the state
func set_handled_node(_handled_node: Node):
	handled_node = _handled_node
	_on_owner_set()
	
func _on_owner_set():
	pass
