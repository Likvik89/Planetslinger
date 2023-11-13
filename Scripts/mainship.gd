extends CharacterBody2D

@export var G = 1000
@export var acceleration := 5.0
@export var rotationspeed := 250.0
@export var maxspeed := 350.0
@export var maxfuel := 200

var fuel = 200

func _physics_process(delta):
	var input_vector := Vector2(0, Input.get_axis("move_forward","move_back"))
	velocity += input_vector.rotated(rotation) * acceleration
	velocity = velocity.limit_length(maxspeed)
	
	if Input.is_action_pressed("rotate_right"):
		rotate(deg_to_rad(rotationspeed*delta))
	
	if Input.is_action_pressed("rotate_left"):
		rotate(deg_to_rad(-rotationspeed*delta))
	
	
	if Input.is_action_pressed("stop"):
		maxspeed = 0
	else:
		maxspeed = 350
	
	if Input.is_action_pressed("move_boost") and fuel > 0:
		acceleration = 10
		maxspeed = 600
		if fuel >= 2:
			fuel -=2
	else:
		acceleration = 5.0
		maxspeed = 200
		fuel +=2
	
	if fuel > maxfuel:
		fuel = maxfuel
	if fuel < 0:
		fuel = 0
	
	move_and_slide()




