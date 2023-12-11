extends Node2D

@export var enemy : PackedScene
@onready var player = $Playership
var cooldown = 1
var spawnspeed = 10

@onready var splo = [$spawnlocation, $spawnlocation2, $spawnlocation3, $spawnlocation4] # spawn locations


func spawn():
	var spawn = enemy.instantiate()
	var spawnlocation = splo[randi() % splo.size()]
	spawn.player = player
	spawn.position = spawnlocation.global_position
	add_child(spawn)
	print("Spawning")

func _process(delta):
	
	if cooldown <= 0:
		spawn()
		cooldown = spawnspeed
	else:
		cooldown -= delta
