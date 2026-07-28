extends Node3D

@export_group("Legacy Camera Settings")
@export var active_position: bool = true
@export var new_add_position: Vector3 = Vector3.ZERO
@export var active_rotate: bool = true
@export var new_rotation: Vector3 = Vector3(45, 45, 0)
@export var active_distance: bool = true
@export var new_distance: float = 25.0
@export var active_speed: bool = true
@export var new_follow_speed: float = 1.2
@export var need_time: float = 2.0

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
	if not use_time:
		_apply_camera()

func trigger_manually() -> void:
	_apply_camera()

func _apply_camera() -> void:
	if not _follower:
		_follower = CameraFollower.instance
	if not _follower:
		return

	var target_offset: Vector3 = _follower.rotator.position if _follower.rotator else Vector3.ZERO
	var target_rotation: Vector3 = _follower.rotator.rotation_degrees if _follower.rotator else Vector3.ZERO
	var target_scale: Vector3 = _follower.scale_node.scale if _follower.scale_node else Vector3.ONE
	var target_fov: float = _follower.camera.fov if _follower.camera else 80.0

	if active_position:
		target_offset = new_add_position
	if active_rotate:
		target_rotation = new_rotation
	if active_speed:
		_follower.follow_speed = Vector3.ONE * new_follow_speed

	_follower.trigger(
		target_offset,
		target_rotation,
		target_scale,
		target_fov,
		need_time,
		Tween.TRANS_SINE,
		Tween.EASE_IN_OUT,
		CameraFollower.RotateMode.FAST_BEYOND_360,
		func() -> void: on_finished.emit()
	)
