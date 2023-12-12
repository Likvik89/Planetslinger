extends CanvasLayer


@onready var gravitymeter = $"gravity meter"
var player



func _process(delta):
	var f = floor((player.mass/player.maxmass)*35)
	gravitymeter.set_frame(f)
