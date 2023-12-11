extends RigidBody2D

#Movement variables
@export var THRUST_FORCE = 25  # The force applied when moving forward
var thrust_force_multiplier = 10000
const rotationspeed = 250.0

#Gravity variables
@export var G = 1000  # Gravitational constant
@export var startmass = 700
@export var gravitychange = 100

#Boosting variables
@export var maxfuel := 200
var fuel = 200

#Repulsion variables
@export var maxrepulseenergi := 400
var repulseenergi = 400
var repulseenergirecovery = 1

#Combat variables
@export var health = 99999.0

@onready var anim = $"Repulsion field/Repulse"



#Taking damge
func take_damage(damage):
	health -= damage

#Collision damage
func _on_area_2d_body_entered(body):
	if body.is_in_group('planets') and body != self:
		take_damage(((self.angular_velocity*self.linear_velocity)-(body.angular_velocity*self.linear_velocity)).length())



func _process(delta):
	#print("Player", health)
	#print("garvity", self.mass)
	if health < 0:
		queue_free()
	
	#Repulsing
	if Input.is_action_pressed("Repulse"):
		if repulseenergi == maxrepulseenergi:
			anim.play("repulse")
			for body in $"Repulsion field".get_overlapping_bodies():
				if body != self:
					var distance = self.global_position.distance_to(body.global_position)
					var direction = (body.global_position - self.global_position).normalized()
					body.apply_central_impulse((direction * 300000 ))
					repulseenergi = 0
	
	if not Input.is_action_pressed("Repulse"):
		repulseenergi += repulseenergirecovery
		if repulseenergi > maxrepulseenergi:
			repulseenergi = maxrepulseenergi
	#print(repenergi)
	
	


func _integrate_forces(delta):
	
	#Changing gravity
	if Input.is_action_just_pressed("gravityup"):
		self.mass += gravitychange
	if Input.is_action_just_pressed("gravitydown"):
		self.mass -= gravitychange
	
	if self.mass < startmass:
		self.mass = startmass
	if self.mass > startmass*4:
		self.mass = startmass*4
	
	#Gravity calculation
	var bodies = get_tree().get_nodes_in_group("planets")
	for body in bodies:
		if body != self:
			var distance = self.global_position.distance_to(body.global_position)
			var force_magnitude = (G * self.mass * body.mass) / (distance * distance)
			var direction = (body.global_position - self.global_position).normalized()
			var force = direction * force_magnitude # combine force magnitude and direction
			apply_central_force(force)
	
	
	#Movement
	look_at(get_global_mouse_position())
	if Input.is_action_pressed("move_forward"):
		var direction = Vector2(cos(rotation), sin(rotation)) 
		apply_central_impulse(direction * THRUST_FORCE * thrust_force_multiplier * delta.step)
	
	if Input.is_action_pressed("move_back"):
		var direction = Vector2(cos(rotation), sin(rotation))  # Calculate backward direction based on rotation
		apply_central_impulse(-direction * THRUST_FORCE * thrust_force_multiplier * delta.step)
	
	
	#Boosting
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

