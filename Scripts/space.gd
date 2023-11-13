extends Node2D


func calculate_gravity_force():
	var sum := Vector2.ZERO
	for target in $bodies.get_children():
		for body in $bodies.get_children():
			if (target != body):
				var distance: Vector2 = body.position - target.position
				var unitVector = distance / distance.length()
				sum += (body.mass * unitVector) / distance.length_squared()
			target.linear_velocity += body.mass * sum


#func _process(delta):
	#calculate_gravity_force()
