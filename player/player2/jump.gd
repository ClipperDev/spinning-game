extends State
class_name Jump


func Enter():
	handled_node.anim.play("jump")
	handled_node.velocity.y -= handled_node.JUMP
	
func Process(_delta: float):
	pass
	
func Physics_Process(delta: float):
	
	handled_node.velocity += handled_node.get_gravity() * delta
	

	
	
func Exit():
	handled_node.velocity.y /= 3
	handled_node.anim.play("RESET")
