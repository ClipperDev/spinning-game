extends State
class_name Walk

func Enter():
	handled_node.anim.play("walk")
	
func Process(_delta: float):
	pass
	
func Physics_Process(delta: float):
	
	handled_node.direction = Input.get_axis("left", "right")
	
	handled_node.velocity.x = move_toward(handled_node.velocity.x, handled_node.SPEED * handled_node.direction, 2000 * delta)
	
	if Input.is_action_just_pressed("jump") and handled_node.is_on_floor():
		Transitioned.emit(self, "jump")
	elif not handled_node.is_on_floor():
		Transitioned.emit(self, "fall")
	
	if !handled_node.direction:
		Transitioned.emit(self, "idle")
	
func Exit():
	handled_node.anim.play("RESET")
