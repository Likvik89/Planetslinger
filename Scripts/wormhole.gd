extends Node2D





func _ready():
	var r = randf_range(0.0, 360.0)
	rotate(r)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
