extends State
class_name Idle

func Enter():
	handled_node.anim.play("idle")
	
func Process(_delta: float):
	pass
	
func Physics_Process(delta: float):
	handled_node.velocity += handled_node.get_gravity() * delta
	
	handled_node.velocity.x = move_toward(handled_node.velocity.x, 0, 2000 * delta)
	
	if Input.get_axis("left", "right"):
		Transitioned.emit(self, "walk")
	
	if Input.is_action_just_pressed("jump") and handled_node.is_on_floor():
		Transitioned.emit(self, "jump")
	elif not handled_node.is_on_floor():
		Transitioned.emit(self, "fall")
	
	
func Exit():
	handled_node.anim.play("RESET")
