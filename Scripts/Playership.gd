extends RigidBody2D

@export var THRUST_FORCE = 25  # The force applied when moving forward
var thrust_force_multiplier = 10000
const rotationspeed = 250.0

@export var G = 1000  # Gravitational constant
@export var startmass = 700
@export var gravitychange = 50

@export var maxfuel := 200
var fuel = 200


func _integrate_forces(delta):
	
	if Input.is_action_just_pressed("gravityup"):
		self.mass += gravitychange
	if Input.is_action_just_pressed("gravitydown"):
		self.mass -= gravitychange
	
	if self.mass < startmass:
		self.mass = startmass
	if self.mass > startmass*2:
		self.mass = startmass*2
	

	
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
	
	if Input.is_action_pressed("move_boost") and fuel > 0:
		THRUST_FORCE = 50
		if fuel >= 2:
			fuel -=2
	else:
		THRUST_FORCE = 25
		fuel += 2
	
	if fuel > maxfuel:
		fuel = maxfuel
	if fuel < 0:
		fuel = 0
	
	
