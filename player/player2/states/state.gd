extends Node
class_name State

signal Transitioned

var handled_node

func Enter():
	pass
	
func Physics_Process(_delta: float):
	pass
	
func Process(_delta: float):
	pass
	
func Exit():
	pass
	
func Set_handled_node(_handled_node):
	handled_node = _handled_node
