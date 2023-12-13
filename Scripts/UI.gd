extends Control

@onready var screensize = get_viewport().size
@onready var gravitymeter = $"CanvasLayer/gravity meter"
@onready var healthmeter = $"CanvasLayer/health o' meter"
@onready var energymeter = $"CanvasLayer/energy batterie"
@onready var fuelmeter = $"CanvasLayer/fuel meter"

@onready var player = $"../playership"



func _process(delta):
	screensize = get_viewport().size
	
	var gf = floor((player.mass/player.maxmass)*35)
	gravitymeter.set_frame(gf)
	gravitymeter.position = Vector2(screensize.x-100, 100)
	
	var hf = floor((player.health/player.maxhealth)*16)
	healthmeter.set_frame(hf)
	healthmeter.position =  Vector2(screensize.x-100, 300)
	
	var ef = floor(player.repulseenergi/player.maxrepulseenergi*15.0)
	energymeter.set_frame(ef)
	energymeter.position = Vector2(screensize.x-76, 400)
	
	var ff = floor(player.fuel/player.maxfuel*48.0)
	fuelmeter.set_frame(ff)
	fuelmeter.position = Vector2(screensize.x-110, 500)
	
	if player.health < 0 or player.health == 0:
		queue_free()
