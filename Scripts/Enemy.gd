extends RigidBody2D

@export var G = 1000  # Gravitational constant
@export var health = 400
@export var player : RigidBody2D


func _integrate_forces(state):
	var bodies = get_tree().get_nodes_in_group("planets")
	for body in bodies:
		if body != self:
			var distance = self.global_position.distance_to(body.global_position)
			var force_magnitude = (G * self.mass * body.mass) / (distance * distance)
			var direction = (body.global_position - self.global_position).normalized()
			var force = direction * force_magnitude # combine force magnitude and direction
			apply_central_force(force)
	
	
	var player_direction = (player.position - position).normalized()
	var player_distance = position.distance_to(player.position)
	var rotation_angle = atan2(player_direction.y, player_direction.x)
	rotation = rotation_angle
	apply_central_force(player_direction*50)


#func _on_area_2d_body_entered(body):
	#print("OUCH!")
	#if body.is_in_group('planets'):
		#print(str('Body entered: ', body.get_name()))
