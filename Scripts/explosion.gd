extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	self.play("default")
	if self.frame == 6:
		print("Exploded")
		queue_free()
