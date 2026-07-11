extends Area3D
@export var tag := 0
@export var stop := false
@export var unautopaly := false
@export var must_trun := false

func _on_autoplay_entered(body: CharacterBody3D) -> void:
	if State.autoplay == true and tag == body.tag and tag == 0 and not unautopaly:
		#await get_tree().create_timer(0.003 * (100/body.speed)).timeout
		body.turn()
	elif must_trun:
		if body.control == false:
			body.control = true
			body.turn()
			body.control = false
		else:
			body.turn()
	if tag > 0 and tag == body.tag:
		body.Turn()
	if stop == true:
		body.stop()
