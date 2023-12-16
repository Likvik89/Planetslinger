extends RigidBody2D

@export var G = 1000  # Gravitational constant
@export var health = 500000
@onready var anim = $AnimatedSprite2D
@export var bl : PackedScene

#Generating a random image, and size for the planet
func _ready():
	
	var random_number = randi() % 100 + 1
	#changeSize(random_number)
	
	var planetSprites = anim.sprite_frames.get_animation_names()
	var randomIndex = randi() % planetSprites.size()
	var randomPlanet = planetSprites[randomIndex]
	anim.play(randomPlanet)



#func _ready():
#	var random_number = randi() % 100 + 1
#	changeSize(random_number)
	
func changeSize(new_size):
	for child in get_children():
		child.scale = Vector2(new_size, new_size)

#Taking damge
func take_damage(damage):
	health -= damage


#Collision damage
func _on_hurtbox_body_entered(body):
	if body.is_in_group('planets') and body != self:
		health -= Vector2((self.angular_velocity*self.linear_velocity)-(body.angular_velocity*self.linear_velocity)).length()

#looping
func _process(delta):
	
	if position.x > 3000:
		position.x = -3000
	
	if position.x < -3000:
		position.x = 3000
	
	if position.y > 3000:
		position.y = -3000
	
	if position.y < -3000:
		position.y = 3000


#Gravity
func _integrate_forces(state):
	var bodies = get_tree().get_nodes_in_group("bodies")
	for body in bodies:
		if body != self:
			var distance = self.global_position.distance_to(body.global_position)
			var force_magnitude = (G * self.mass * body.mass) / (distance * distance)
			var direction = (body.global_position - self.global_position).normalized()
			var force = direction * force_magnitude # combine force magnitude and direction
			apply_central_force(force)


#spawnig black holes
var being_absorbed = false
func _on_blackholemaker_body_entered(body):
	var total_mass = 0
	var overlaps = $blackholemaker.get_overlapping_bodies()
	for thing in overlaps:
		if thing.is_in_group("planets"):
			if not thing.being_absorbed:
				total_mass += thing.mass
	if total_mass > 1000:
		being_absorbed = true
		var hol = bl.instantiate()
		hol.position = position
		$"../".add_child(hol)


#being absorbed by a black hole
func get_absorbed(pos):
	var tween = get_tree().create_tween()
	var tween2 = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(), 1)
	tween2.tween_property(self, "position", pos, 1)
	tween.tween_callback(queue_free)
