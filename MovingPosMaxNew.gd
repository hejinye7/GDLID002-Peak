@tool
extends Area3D

@export var animated_object: Node3D
@export var points: Array[MovingPosPoint] = []

@export var one_shot: bool = false
var triggered: bool = false

signal on_animation_start
signal on_animation_end
signal hit_the_line  # 自定义触发信号

# ---------- 工具按钮 ----------
@export_tool_button("添加当前位置（向后添加）") var add_pos_action = func():
	var new_point := MovingPosPoint.new()
	new_point.pos = _get_target_position()
	points.append(new_point)
	print("终点已添加: ", new_point.pos)
	notify_property_list_changed()

@export_tool_button("预览播放") var preview_play_action = func():
	if Engine.is_editor_hint():
		play_sequence(true)

# ---------- 核心逻辑 ----------
func _ready() -> void:
#	$MeshInstance3D.visible = false
	if !points.is_empty():
		hit_the_line.connect(play_sequence)

func _on_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		emit_signal("hit_the_line")
		if one_shot and triggered:
			return
		triggered = true

func play_sequence(editor_preview: bool = false) -> void:
	if points.is_empty():
		push_warning("没有设置路径点！")
		return

	on_animation_start.emit()
	var target = animated_object if animated_object else self
	var start_pos = target.global_position
	var tween = create_tween()
	for point in points:
		tween.tween_property(target, "global_position", point.pos, point.postime).set_trans(point.ease)
		if point.waittime > 0.0:
			tween.tween_interval(point.waittime)

	tween.tween_callback(func():
		on_animation_end.emit()
	)
	
	if editor_preview:
		tween.tween_interval(1.0)
		tween.tween_property(target, "global_position", start_pos, 0.1)

func play_():
	play_sequence()

func _get_target_position() -> Vector3:
	var target = animated_object if animated_object else self
	return target.global_position
