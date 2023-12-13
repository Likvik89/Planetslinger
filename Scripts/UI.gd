extends Control

@onready var screensize = get_viewport().size
@onready var gravitymeter = $"CanvasLayer/gravity meter"
@onready var healthmeter = $"CanvasLayer/health o' meter"
@onready var energymeter = $"CanvasLayer/energy batterie"

var player



func _process(delta):
	screensize = get_viewport().size
	
	var gf = floor((player.mass/player.maxmass)*35)
	gravitymeter.set_frame(gf)
	gravitymeter.position = Vector2(screensize.x-100, 100)
	
	var hf = floor((player.health/player.maxhealth)*16)
	healthmeter.set_frame(hf)
	healthmeter.position =  Vector2(screensize.x-100, 300)
	
	var ef = floor(player.repulseenergi/player.maxrepulseenergi*15)
	energymeter.set_frame(ef)
	energymeter.position = Vector2(screensize.x-76, 400)
