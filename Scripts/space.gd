extends Node2D

@export var planet : PackedScene
@export var wormhole : PackedScene
var spawnamount = randi_range(10,20)
@onready var gameoverscreen = $Enemyspawner/Gameover
@onready var player = $Enemyspawner/playership



func spawn():
	var spawn = planet.instantiate()
	var spawndistance = randi_range(500.0,2700.0)
	var spawnangle = randi_range(0.0,360.0)
	var direction = Vector2(cos(spawnangle), sin(spawnangle))
	var spawnposition = Vector2(direction*spawndistance)
	
	spawn.position = spawnposition
	add_child(spawn)

func make_wormhole():
	var spawn = wormhole.instantiate()
	var spawndistance = randi_range(500.0,2700.0)
	var spawnangle = randi_range(0.0,360.0)
	var direction = Vector2(cos(spawnangle), sin(spawnangle))
	var spawnposition = Vector2(direction*spawndistance)
	
	spawn.position = spawnposition
	spawn.player = player
	add_child(spawn)

func _ready():
	$"Background music".play()
	for i in range(spawnamount):
		spawn()



func _process(delta):
	if player != null:
		Score.playerposition = player.position
	
	if player == null:
		$Camera2D.position = Score.playerposition
		$Camera2D.enabled = true
		gameoverscreen.position = Score.playerposition
		gameoverscreen.visible = true
		$"Enemyspawner/Gameover/ded".play()




#Old gravity calculation
func x_ready():
	var sum := Vector2.ZERO
	for target in $bodies.get_children():
		for body in $bodies.get_children():
			if (target != body):
				var distance: Vector2 = body.position - target.position
				var unitVector = distance / distance.length()
				sum += (body.mass * unitVector) / distance.length_squared()
			target.linear_velocity += body.mass * sum

