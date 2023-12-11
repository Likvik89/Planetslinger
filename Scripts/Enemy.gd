extends RigidBody2D

@export var G = 1000  # Gravitational constant
@export var health = 400

#Movement variables
var player
@export var speed = 600
@export var safetydistance = 0

#Shooting variables
@export var bullet : PackedScene
@export var firingspeed = 5
@export var cooldown = 0


func start(_position, _direction):
	rotation = _direction
	position = _position

#Collision damage
func _on_area_2d_body_entered(body):
	if body.is_in_group('planets') and body != self:
		health -= Vector2((self.linear_velocity)-(body.linear_velocity)).length()
	#print(health)
	
#Shooting
func shoot():
	print("Shooting")
	var prjctl = bullet.instantiate()
	prjctl.start($Marker2D.global_position, rotation)
	get_tree().root.add_child(prjctl)

#Making sure that it doesn't shoot while biting
func _process(delta):
	if player != null:
		var player_distance = position.distance_to(player.position)
		if player_distance > 30:
			if cooldown <= 0:
				shoot()
				cooldown = firingspeed
			else:
				cooldown -= delta
		if health < 0:
			queue_free()

#Gravity/movement
func _integrate_forces(state):
	#Gravity
	var bodies = get_tree().get_nodes_in_group("planets")
	for body in bodies:
		if body != self:
			var distance = self.global_position.distance_to(body.global_position)
			var force_magnitude = (G * self.mass * body.mass) / (distance * distance)
			var direction = (body.global_position - self.global_position).normalized()
			var force = direction * force_magnitude # combine force magnitude and direction
			apply_central_force(force)
	
	#Movement
	if player != null:
		var player_direction = (player.position - position).normalized()
		var player_distance = position.distance_to(player.position)
		var rotation_angle = atan2(player_direction.y, player_direction.x)
		rotation = rotation_angle
		if player_distance > safetydistance:
			apply_impulse(player_direction*speed)
		else:
			apply_impulse(-player_direction*speed)

