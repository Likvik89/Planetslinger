extends RigidBody2D

#func _on_multiblackhole_body_entered(body):
#	if body.is_in_group("blackholes"):
		

func _on_absorb_body_entered(body):
	if body.is_in_group("bodies"):
		body.being_absorbed = true
		self.mass += body.mass
		body.get_absorbed(position)
