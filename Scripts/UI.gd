extends Control

@onready var screensize = get_viewport().size
@onready var gravitymeter = $"CanvasLayer/gravity meter"
var player



func _process(delta):
	var f = floor((player.mass/player.maxmass)*35)
	gravitymeter.set_frame(f)
	screensize = get_viewport().size
	gravitymeter.position = Vector2(screensize.x-100, 100)
