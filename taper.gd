extends Node3D
var check := false

func _on_taper_entered(body: CharacterBody3D) -> void:
	check = true
	if $autoplay.tag < 1:
		body.check = true

func _on_taper_exited(body: CharacterBody3D) -> void:
	check = false

func _input(event: InputEvent) -> void:
	if $autoplay.tag < 1 and not State.autoplay:
		if event.is_action_pressed("turn"):
			if check:
				check = false
				if not State.is_end:
					$AnimationPlayer.play("taper")
