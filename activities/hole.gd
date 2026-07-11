extends TextureRect

@export var tag := 0

func light() -> void:
	var ball = State.user_data.ball
	if ball >= tag:
		texture = preload("res://Resources/ui/other/lightball.png")
	else:
		texture = preload("res://activities/hole.png")
