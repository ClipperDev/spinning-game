extends State
class_name Walk

var backwards: bool

func Enter():
	pass
	
	
	
func Process(_delta: float):
	print(handled_node.lookdir, " ", handled_node.direction)
	
func Physics_Process(delta: float):
	if float(handled_node.lookdir) == handled_node.direction:
		handled_node.anim.play("walk_forwards")
	else: handled_node.anim.play("walk_backwards")
	
	handled_node.direction = Input.get_axis("left", "right")
	
	#backward/forward anim
	
	handled_node.velocity.x = move_toward(
		handled_node.velocity.x, handled_node.SPEED * handled_node.direction, 2000 * delta
		)
	
	if Input.is_action_just_pressed("jump") and handled_node.is_on_floor():
		Transitioned.emit(self, "jump")
	elif not handled_node.is_on_floor():
		Transitioned.emit(self, "fall")
	
	if !handled_node.direction:
		Transitioned.emit(self, "idle")
	
func Exit():
	handled_node.anim.play("RESET")
