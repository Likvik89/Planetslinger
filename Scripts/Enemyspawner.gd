extends Node2D

@export var enemy : PackedScene
@onready var player = $Playership
var cooldown = 0
var spawnspeed = 5


func _ready():
	$"Gameplay UI".player = player


func spawn():
	
	if player != null:
		var spawn = enemy.instantiate()
		var spawndistance = randi_range(500.0,700.0)
		var spawnangle = randi_range(0.0,360.0)
		var direction = Vector2(cos(spawnangle), sin(spawnangle))
		var spawnposition = player.position + Vector2(direction*spawndistance)
		
		
		spawn.position = spawnposition
		spawn.player = player
		add_child(spawn)

func _process(delta):
	
	
	if cooldown <= 0:
		spawn()
		cooldown = spawnspeed
	else:
		cooldown -= delta
