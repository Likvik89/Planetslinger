extends Control

@export var player : PackedScene

func _ready():
	$ded.play()
	$Score.text = str(Score.score)
	if Score.score > Score.highscore:
		Score.highscore = Score.score
	$Highscore.text = str(Score.highscore)
	Score.score = 0



func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/spaece.tscn")


func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
	queue_free()
