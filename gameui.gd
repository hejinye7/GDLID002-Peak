extends Control
@export var line : CharacterBody3D
@export var title : bool = false
@export var levelname := "level name"
@export var music_length := 0.0
@export var end_wait_time := 0.0
@export var paused : Control
var percent_time := 0.0
var 一 := false
var 二 := false
var 三 := false


@export var moreline := false

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	$".".visible = false
	if paused:
		paused.visible = true
	percent_time = music_length/100

 
func start() -> void:
		for i in range(100) :
			if State.is_relive == false and not State.is_end:
				await get_tree().create_timer(percent_time).timeout
				State.percent += 1
				if line.is_live == false:
					二 = false
					break

func _process(delta: float) -> void:
	if not 一:
		if not line.is_live:
			visible()
		if State.is_end and not 三:
			三 = true
			await get_tree().create_timer(end_wait_time).timeout
			visible()
			print("1")

func visible() -> void:
	State.crown_num()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	一 = true
	if paused:
		paused.visible = false
	if State.is_relive == true:
		State.crown -= 1
		pass
	if State.diamond > 10:
		State.diamond = 10
	$diamond.text = str(State.diamond,"/10")
	if title:
		$title.text = levelname
	else:
		$title.text = State.leveldata.level_group[State.level].chinese_name
	if State.is_end:
		State.percent = 100
		$percent.text = str(State.percent,"%")
	else :
		$percent.text = str(State.percent,"%")
	
	
	
	State.crown_num()
	if State.crown == 0:
		$Control/PerfactCrownNoLight.texture = preload("res://CrownNoLight.png")
		$Control/PerfactCrownNoLight2.texture = preload("res://CrownNoLight.png")
		$Control/PerfactCrownNoLight3.texture = preload("res://CrownNoLight.png")
		State.percent = 0
	elif State.crown == 1:
		$AnimationPlayer.play("1crown")
	elif State.crown == 2:
		$AnimationPlayer.play("2crown")
	elif State.crown == 3:
		if State.diamond == 10 and State.percent == 100:
			$AnimationPlayer.play("perfect crown")
		else :
			$AnimationPlayer.play("3crown")
	else :
		$Control/PerfactCrownNoLight.texture = preload("res://CrownNoLight.png")
		$Control/PerfactCrownNoLight2.texture = preload("res://CrownNoLight.png")
		$Control/PerfactCrownNoLight3.texture = preload("res://CrownNoLight.png")
	$ProgressBar.value = float($percent.text)
	if State.diamond == 10 and State.crown == 3 and State.percent == 100:
		$Control2/star.texture = load("res://star.png")
	else :
		$Control2/star.texture = load("res://unstar.png")
	$".".visible = true
	$coin/halfwhitebar/coin.text = str(State.user_data.coin)
	$coin/bar1/Label.text = str("+",State.save()," coin")
	$coin/AnimationPlayer.play("coin")
	await get_tree().create_timer(2.25).timeout
	$coin/halfwhitebar/coin.text = str(State.user_data.coin)


func _on_back_pressed() -> void:
	State.quit(line)



func _on_gameplay_pressed() -> void:
	$MessageBal/Label.text = State.fuhuo(line)
	$MessageBal/AnimationPlayer.play("messagebal")

func _on_gamereplay_pressed() -> void:
	State.replay(line)


func _input(event: InputEvent) -> void:
	if not Engine.is_editor_hint():
		if moreline:
			if event.is_action_pressed("turn") or event.is_action_pressed("turn1") or event.is_action_pressed("turn2") and line.is_live:
				if 二 == false:
					start()
					二 = true
		else:
			if event.is_action_pressed("turn"):
				if 二 == false:
					start()
					二 = true
