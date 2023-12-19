extends Node2D


@export var enemy : PackedScene
@export var planet : PackedScene
var player

var spawnspeed = 10
var cooldown = 0


func _ready():
	var r = randf_range(0.0, 360.0)
	rotate(r)


func spawn():
	var spawn
	
	#selecting what to spawn
	var spawnindex = randi_range(0,1)
	if spawnindex == 0:
		spawn = planet.instantiate()
	if spawnindex == 1:
		spawn = enemy.instantiate()
	
	#selecting "launch angle"
	var spawnangle = randi_range(-45,45)
	var direction = Vector2(cos(spawnangle), sin(spawnangle))
	var spawnposition = Vector2(direction*150)
	
	
	
	spawn.position = position
	if spawn == enemy:
		spawn.player = player
	
	
	
	$"../".add_child(spawn)
	

func _process(delta):
	
	if cooldown <= 0:
		spawn()
		cooldown = spawnspeed + randi_range(0,2)
	else:
		cooldown -= delta

