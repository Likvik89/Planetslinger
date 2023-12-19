extends RigidBody2D

#Movement variables
@export var THRUST_FORCE = 25  # The force applied when moving forward
var thrust_force_multiplier = 10000
const rotationspeed = 250.0

#Gravity variables
@export var G = 1000  # Gravitational constant
@export var startmass = 700
@export var gravitychange = 200
var maxmass = startmass*4

#Boosting variables
@export var maxfuel := 200.0
var fuel = 200.0

#Repulsion variables
@export var maxrepulseenergi := 400.0
var repulseenergi = 400.0
var repulseenergirecovery = 1

#Combat variables
var health = 1.0
@export var maxhealth = 99999.0


@onready var anim = $"Repulsion field/Repulse"
@onready var exhaustanim = $exhaust
#@export var death : PackedScene 

#Taking damge
func take_damage(damage):
	if damage > 49:
		health -= damage

var being_absorbed = false
#being absorbed by a black hole
func get_absorbed(pos):
	var tween = get_tree().create_tween()
	var tween2 = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(), 1)
	tween2.tween_property(self, "position", pos, 1)
	tween.tween_callback(queue_free)


#Collision damage
func _on_area_2d_body_entered(body):
	if body.is_in_group('planets') and body != self:
		take_damage(((self.angular_velocity*self.linear_velocity)-(body.angular_velocity*self.linear_velocity)).length())


#Repulsing
func _process(delta):
	
	if health < 0 or health == 0:
		
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
	
	if position.x > 3000:
		position.x = -3000
	
	if position.x < -3000:
		position.x = 3000
	
	if position.y > 3000:
		position.y = -3000
	
	if position.y < -3000:
		position.y = 3000


#Gravity
#Movement
func _integrate_forces(delta):
	
	#Changing gravity
	if Input.is_action_just_pressed("gravityup"):
		self.mass += gravitychange
	if Input.is_action_just_pressed("gravitydown"):
		self.mass -= gravitychange
	
	if self.mass < startmass:
		self.mass = startmass
	if self.mass > maxmass:
		self.mass = maxmass
	
	#Gravity calculation
	var bodies = get_tree().get_nodes_in_group("bodies")
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
	
	
	if Input.is_action_just_pressed("move_forward"):
		$exaust.play()
	elif Input.is_action_just_released("move_forward"):
		$exaust.stop()
	
	
	#Boosting
	if Input.is_action_pressed("move_boost") and fuel > 0:
		THRUST_FORCE = 50
		exhaustanim.play("boosting")
		if fuel >= 2:
			fuel -=2
	else:
		THRUST_FORCE = 25
		fuel += 2
		exhaustanim.play("default")
	
	
	if fuel > maxfuel:
		fuel = maxfuel
	if fuel < 0:
		fuel = 0

