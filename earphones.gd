extends Node3D
@export var line : CharacterBody3D

func _input(event: InputEvent) -> void:
	if not Engine.is_editor_hint():
		if event.is_action_pressed("turn") and not State.is_end and line.is_live and line.is_on_floor() and not State.autoplay:
			$GPUParticles3D.emitting = true
		else:
			if OS.has_feature("android"):
				await get_tree().create_timer(0.1).timeout
			$GPUParticles3D.emitting = false

func note() -> void:
	$GPUParticles3D.emitting = true
	await get_tree().create_timer(0.1).timeout
	$GPUParticles3D.emitting = false
