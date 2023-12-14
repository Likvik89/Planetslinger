extends RigidBody2D



func _on_area_2d_body_entered(body):
	if body.is_in_group("bodies"):
		self.mass += body.mass
		body.queue_free()
