extends Node3D

@export_group("Legacy Camera Settings")
@export var use_legacy_parameters: bool = false
@export var set_camera: NodePath
@export var active_position: bool = true
@export var new_add_position: Vector3 = Vector3.ZERO
@export var active_rotate: bool = true
@export var new_rotation: Vector3 = Vector3(45, 45, 0)
@export var active_distance: bool = true
@export var new_distance: float = 25.0
@export var active_speed: bool = true
@export var new_follow_speed: float = 1.2
@export var need_time: float = 2.0

@export_group("Camera Settings")
@export var offset: Vector3 = Vector3.ZERO
@export var camera_rotation: Vector3 = Vector3(54, 45, 0)
@export var camera_scale: Vector3 = Vector3.ONE
@export_range(0.0, 179.0) var field_of_view: float = 80.0
@export var follow: bool = true

@export_group("Animation")
@export var duration: float = 2.0
@export var use_curve: bool = false
@export var transition_type: Tween.TransitionType = Tween.TRANS_SINE
@export var ease_type: Tween.EaseType = Tween.EASE_IN_OUT
@export var curve: Curve
@export var rotation_mode: CameraFollower.RotateMode = CameraFollower.RotateMode.FAST_BEYOND_360
@export var can_be_triggered: bool = true

@export_group("时间判定")
@export var use_time: bool = false
@export var trigger_time: float = 0.0

signal on_finished

var _follower: CameraFollower = null
var _time_triggered: bool = false

func _ready() -> void:
	set_process(use_time)

func _process(_delta: float) -> void:
	if use_time and not _time_triggered and LevelManager.anim_time >= trigger_time:
		_time_triggered = true
		_apply_camera()
		set_process(false)

func trigger(_body: Node3D) -> void:
	if not use_time and can_be_triggered:
		_apply_camera()

func trigger_manually() -> void:
	if not can_be_triggered:
		_apply_camera()

func _apply_camera() -> void:
	if not _follower:
		_follower = CameraFollower.instance
	if not _follower:
		return

	var target_offset: Vector3 = offset
	var target_rotation: Vector3 = camera_rotation
	var target_scale: Vector3 = camera_scale
	var target_fov: float = field_of_view
	var tween_duration: float = duration

	if use_legacy_parameters:
		tween_duration = need_time
		if active_position:
			target_offset = new_add_position
		elif _follower.rotator:
			target_offset = _follower.rotator.position
		if active_rotate:
			target_rotation = new_rotation
		elif _follower.rotator:
			target_rotation = _follower.rotator.rotation_degrees
		if _follower.scale_node:
			target_scale = _follower.scale_node.scale
		if _follower.camera:
			target_fov = _follower.camera.fov
		if active_speed:
			_follower.follow_speed = Vector3.ONE * new_follow_speed

	_follower.follow = follow
	_follower.trigger(
		target_offset,
		target_rotation,
		target_scale,
		target_fov,
		tween_duration,
		transition_type,
		ease_type,
		rotation_mode,
		func() -> void: on_finished.emit(),
		use_curve,
		curve
	)
