extends Area3D

func _process(delta: float) -> void:
	if State.user_data.ball >= 5 or State.autoplay == true:
		$"../AnimationPlayer".play("ball")
		await $"../AnimationPlayer".animation_finished
		$"..".visible = false
		queue_free()
	else :
		$"..".visible = true


func _on_body_entered(body: CharacterBody3D) -> void:
	State.user_data.coin += 1
	State.user_data.ball += 1
	State.save_runtime_data()
	$"../AnimationPlayer".play("ball")
	await $"../AnimationPlayer".animation_finished
	queue_free()
