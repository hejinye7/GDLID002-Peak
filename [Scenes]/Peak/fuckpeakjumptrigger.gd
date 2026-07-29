@tool
extends Node

func trigger(body: Node3D) -> void:
	var character: CharacterBody3D = body as CharacterBody3D
	if character:
		character.velocity.y = 0.0