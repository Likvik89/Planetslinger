extends RigidBody2D

@export var G = 1000  # Gravitational constant
@export var health = 500000
@onready var anim = $AnimatedSprite2D


#Generating a random image for the planet
func _ready():
	var planetSprites = anim.sprite_frames.get_animation_names()
	var randomIndex = randi() % planetSprites.size()
	var randomPlanet = planetSprites[randomIndex]
	anim.play(randomPlanet)


#Taking damge
func take_damage(damage):
	health -= damage


#Collision damage
func _on_hurtbox_body_entered(body):
	if body.is_in_group('planets') and body != self:
		health -= Vector2((self.angular_velocity*self.linear_velocity)-(body.angular_velocity*self.linear_velocity)).length()

#Gravity
func _integrate_forces(state):
	var bodies = get_tree().get_nodes_in_group("planets")
	for body in bodies:
		if body != self:
			var distance = self.global_position.distance_to(body.global_position)
			var force_magnitude = (G * self.mass * body.mass) / (distance * distance)
			var direction = (body.global_position - self.global_position).normalized()
			var force = direction * force_magnitude # combine force magnitude and direction
			apply_central_force(force)

