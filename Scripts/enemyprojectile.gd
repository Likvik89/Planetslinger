extends CharacterBody2D

@export var speed = 200

func start(_position, _direction):
	rotation = _direction
	position = _position
	velocity = Vector2(speed, 0).rotated(rotation)

#Movement
func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	
	if position.x > 3000:
		position.x = -3000
	
	if position.x < -3000:
		position.x = 3000
	
	if position.y > 3000:
		position.y = -3000
	
	if position.y < -3000:
		position.y = 3000


#Collision detection
func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(100)
		queue_free()
	else:
		queue_free()
