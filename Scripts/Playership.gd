extends RigidBody2D

#Movement variables
@export var THRUST_FORCE = 25  # The force applied when moving forward
var thrust_force_multiplier = 10000
const rotationspeed = 250.0
var maxspeed = 0

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
var health = 99999.0
@export var maxhealth = 99999.0

var start_grablenght = 500
var max_grablenght = 1000
var grablenght_change = 50

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


#Gravity
#Movement
func _integrate_forces(delta):
	
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
		if linear_velocity.length() < maxspeed:
			apply_central_impulse(direction * THRUST_FORCE * thrust_force_multiplier * delta.step)
		else:
			apply_central_force(direction * THRUST_FORCE * thrust_force_multiplier * delta.step)
	
	if Input.is_action_pressed("move_back"):
		var direction = Vector2(cos(rotation), sin(rotation))  # Calculate backward direction based on rotation
		if linear_velocity.length() < maxspeed:
			apply_central_impulse(-direction * THRUST_FORCE * thrust_force_multiplier * delta.step)
		else:
			apply_central_force(-direction * THRUST_FORCE * thrust_force_multiplier * delta.step)
	
	if Input.is_action_just_pressed("move_forward"):
		$exaust.play()
	elif Input.is_action_just_released("move_forward"):
		$exaust.stop()
	
	if global_position.x < -2999:
		global_position.x = 2999
	if global_position.x > 2999:
		global_position.x = -2999
	
	
	#Boosting
	if Input.is_action_pressed("move_boost") and fuel > 0:
		THRUST_FORCE = 50
		exhaustanim.play("boosting")
		maxspeed = 1600
		if fuel >= 2:
			fuel -=2
	else:
		THRUST_FORCE = 25
		fuel += 2
		maxspeed -= 2
		exhaustanim.play("default")
	
	if fuel > maxfuel:
		fuel = maxfuel
	if fuel < 0:
		fuel = 0
	
	if maxspeed < 900:
		maxspeed = 900

#Grapple length
#Repulsing
#"Looping"
func _process(delta):
	Score.playerposition = self.global_position
	#Changing gravity
	if Input.is_action_just_pressed("gravityup"):
		Score.grablenght += grablenght_change
	if Input.is_action_just_pressed("gravitydown"):
		Score.grablenght -= grablenght_change
	
	if Score.grablenght < start_grablenght:
		Score.grablenght = start_grablenght
	if Score.grablenght > max_grablenght:
		Score.grablenght = max_grablenght
	
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
	
	#"Looping"
	if position.x > 2000:
		position.x = -2000
	
	if position.x < -2000:
		position.x = 2000
	
	if position.y > 2000:
		position.y = -2000
	
	if position.y < -2000:
		position.y = 2000
