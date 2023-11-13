extends RigidBody2D

@export var G = 1000  # Gravitational constant
#@onready var anim = $AnimatedSprite2D

#func _ready():
	#var planetSprites = anim.sprite_frames.get_animation_names()
	#var randomIndex = randi() % planetSprites.size()
	#var randomPlanet = planetSprites[randomIndex]
	#anim.play(randomPlanet)
	

func x_integrate_forces(state):
	var bodies = get_tree().get_nodes_in_group("planets")
	for body in bodies:
		if body != self:
			var distance = self.global_position.distance_to(body.global_position)
			var force_magnitude = (G * self.mass * body.mass) / (distance * distance)
			var direction = (body.global_position - self.global_position).normalized()
			var force = direction * force_magnitude
			apply_central_force(force)

			print(force)
