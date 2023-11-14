extends RigidBody2D

@export var THRUST_FORCE = 25  # The force applied when moving forward
var thrust_force_multiplier = 10000
const rotationspeed = 250.0
@export var G = 1000  # Gravitational constant

func _integrate_forces(delta):
	var bodies = get_tree().get_nodes_in_group("planets")
	for body in bodies:
		if body != self:
			var distance = self.global_position.distance_to(body.global_position)
			var force_magnitude = (G * self.mass * body.mass) / (distance * distance)
			var direction = (body.global_position - self.global_position).normalized()
			var force = direction * force_magnitude # combine force magnitude and direction
			apply_central_force(force) 
			
	look_at(get_global_mouse_position())
	# Apply thrust when moving forward
	if Input.is_action_pressed("move_forward"):
		var direction = Vector2(cos(rotation), sin(rotation))  # Calculate forward direction based on rotation
		apply_central_impulse(direction * THRUST_FORCE * thrust_force_multiplier * delta.step)

	# Apply reverse thrust when moving backward
	if Input.is_action_pressed("move_back"):
		var direction = Vector2(cos(rotation), sin(rotation))  # Calculate backward direction based on rotation
		apply_central_impulse(-direction * THRUST_FORCE * thrust_force_multiplier * delta.step)

