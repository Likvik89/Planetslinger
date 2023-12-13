extends Control

func _ready():
	$Score.text = str(Score.score)
	if Score.score > Score.highscore:
		Score.highscore = Score.score
	$Highscore.text = str(Score.highscore)
	Score.score = 0


func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/spaece.tscn")
