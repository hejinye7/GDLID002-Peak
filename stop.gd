extends Button
@export var line : CharacterBody3D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	$"../Kuang".visible = false
	$".".visible = true
	$"../Control/continue".visible = false
	$"../Control/quit".visible = false
	$"../Control/replay".visible = false
	$"../time".visible = false

func _on_stop_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$"../Kuang".visible = true
	$"../Control/continue".visible = true
	$"../Control/quit".visible = true
	$"../Control/replay".visible = true
	get_tree().paused = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if $"../Kuang".visible == false:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			$"../Kuang".visible = true
			$"../Control/continue".visible = true
			$"../Control/quit".visible = true
			$"../Control/replay".visible = true
			get_tree().paused = true
		elif $"../time".visible == true:
			pass
		else:
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
			$"../Control/continue".visible = false
			$"../Control/quit".visible = false
			$"../Control/replay".visible = false
			$"../time".visible = true
			$"../AnimationPlayer".play("time")
			await $"../AnimationPlayer".animation_finished
			$"../time".visible = false
			$"../Kuang".visible = false
			get_tree().paused = false

func _on_continue_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	$"../Control/continue".visible = false
	$"../Control/quit".visible = false
	$"../Control/replay".visible = false
	$"../time".visible = true
	$"../AnimationPlayer".play("time")
	await $"../AnimationPlayer".animation_finished
	$"../time".visible = false
	$"../Kuang".visible = false
	get_tree().paused = false

func _on_quit_pressed() -> void:
	get_tree().paused = false
	State.quit(line)

func _on_replay_pressed() -> void:
	get_tree().paused = false
	State.replay(line)
