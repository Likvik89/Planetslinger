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
	$Marker2D.position = Vector2(direction*150)
	var spawnposition = $Marker2D.position
	
	spawn.scale = Vector2()
	
	var tween = get_tree().create_tween()
	var tween2 = get_tree().create_tween()
	tween.tween_property(spawn, "scale", Vector2(1,1), 1)
	tween2.tween_property(spawn, "position", spawnposition, 1)
	spawn.apply_central_impulse(direction*200)
	
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

