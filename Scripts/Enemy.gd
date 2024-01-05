extends RigidBody2D

@export var G = 1000  # Gravitational constant
@export var health = 350
@export var explosion : PackedScene

#Movement variables
var player
@export var speed = 600
@export var safetydistance = randi_range(0,50)

#Shooting variables
@export var bullet : PackedScene
@export var firingspeed = 5
@export var cooldown = 0


func start(_position, _direction):
	rotation = _direction
	position = _position

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
		health -= Vector2((self.linear_velocity)-(body.linear_velocity)).length()
	#print(health)
	
#Shooting
func shoot():
	$pew.play()
	var prjctl = bullet.instantiate()
	prjctl.start($Marker2D.global_position, rotation)
	get_tree().root.add_child(prjctl)

#Making sure that it doesn't shoot while biting
#Dying
func _process(delta):
	if player != null:
		var player_distance = position.distance_to(player.position)
		if player_distance > 30:
			if cooldown <= 0:
				shoot()
				cooldown = firingspeed + randf_range(0,2)
			else:
				cooldown -= delta 
		#Dying
		if health <= 0:
			Score.score += 300
			var kapow = explosion.instantiate()
			kapow.position = self.position
			get_tree().root.add_child(kapow)
			queue_free()
	
	if position.x > 2000:
		position.x = -2000
	
	if position.x < -2000:
		position.x = 2000
	
	if position.y > 2000:
		position.y = -2000
	
	if position.y < -2000:
		position.y = 2000


#Gravity/movement
func _integrate_forces(state):
	#Gravity
	var bodies = get_tree().get_nodes_in_group("bodies")
	for body in bodies:
		if body != self:
			var distance = self.global_position.distance_to(body.global_position)
			var force_magnitude = (G * self.mass * body.mass) / (distance * distance)
			var direction = (body.global_position - self.global_position).normalized()
			var force = direction * force_magnitude # combine force magnitude and direction
			apply_central_force(force)
	
	#Movement
	if player != null:
		if ! self.linear_velocity.length() > 5000: 
			var player_direction = (player.position - position).normalized()
			var player_distance = position.distance_to(player.position)
			var rotation_angle = atan2(player_direction.y, player_direction.x)
			rotation = rotation_angle
			if player_distance > safetydistance:
				apply_impulse(player_direction*speed)
			else:
				apply_impulse(-player_direction*speed)

