extends Area2D

#Biting
func _process(delta):
	for body in get_overlapping_bodies():
		if body.is_in_group("player"):
			body.take_damage(1)
