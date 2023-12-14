extends Control

func _ready():
	$ded.play()
	%Score.text = str("Score=",Score.score)
	if Score.score > Score.highscore:
		Score.highscore = Score.score
	%Highscore.text = str("Highscore =",Score.highscore)
	Score.score = 0



func _on_retry_pressed():
	get_tree().change_scene_to_file("res://Scenes/spaece.tscn")
