extends Node2D

@export var enemy : PackedScene
var cooldown = 0
var spawnspeed = 10


func spawn():
	var spawn = enemy.instantiate()
	get_tree().root.add_child(spawn)
	print("Spawning")

func _process(delta):
	
	if cooldown <= 0:
		spawn()
		cooldown = spawnspeed
	else:
		cooldown -= delta
