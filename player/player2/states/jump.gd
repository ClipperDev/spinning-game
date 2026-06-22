extends State
class_name Jump


func Enter():
	handled_node.anim.play("jumpfall")
	handled_node.velocity.y -= handled_node.JUMP
	
func Process(_delta: float):
	pass
	
func Physics_Process(delta: float):
	handled_node.velocity += handled_node.get_gravity() * delta
	
	handled_node.direction = Input.get_axis("left", "right")
	
	handled_node.velocity.x = move_toward(
		handled_node.velocity.x, handled_node.SPEED * handled_node.direction, 2000 * delta
		)
		
	if Input.is_action_just_released("jump"):
		Transitioned.emit(self, "fall")
	if handled_node.is_on_floor():
		Transitioned.emit(self, "idle")
	
	
func Exit():
	handled_node.velocity.y /= 2
	handled_node.anim.play("RESET")
