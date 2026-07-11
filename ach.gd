extends Sprite2D

func _ready() -> void:
	visible = false

func ach(name:String) -> void:
	var config = ConfigFile.new()
	var result = config.load_encrypted_pass("user://playerdata.shl",State.key)
	if config.get_value("ach",name) != 1:
		config.set_value("ach",name,1)
		config.save_encrypted_pass("user://playerdata.shl",State.key)
		$ach.text = name
		visible = true
		$AnimationPlayer.play("ach")
		await $AnimationPlayer.animation_finished
		visible = false
