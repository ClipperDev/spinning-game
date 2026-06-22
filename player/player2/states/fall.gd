extends State
class_name Fall

func Enter():
	handled_node.anim.play("jumpfall")
	
func Physics_Process(delta: float):
	handled_node.velocity += handled_node.get_gravity() * delta
	
	handled_node.direction = Input.get_axis("left", "right")
	
	handled_node.velocity.x = move_toward(
		handled_node.velocity.x, handled_node.SPEED * handled_node.direction, 2000 * delta
		)
		

	if handled_node.is_on_floor():
		Transitioned.emit(self, "idle")
	
func Exit():
	handled_node.anim.play("RESET")
