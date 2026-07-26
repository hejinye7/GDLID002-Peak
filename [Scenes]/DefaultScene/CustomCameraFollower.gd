extends Node3D
class_name CustomCameraFollower

static var instance: CustomCameraFollower

@export var player: NodePath
@export var add_position: Vector3 = Vector3.ZERO
@export var rotation_offset: Vector3 = Vector3(45, 45, 0)
@export var distance_from_object: float = 25.0
@export var follow_speed: float = 1.2
@export var following: bool = true

@onready var player_node: Node3D = get_node(player) if player else null
@onready var camera: Node3D = get_child(0) if get_child_count() > 0 else null

var do_pos: Tween
var do_rot: Tween
var do_dis: Tween
var do_spe: Tween

var pos_e: Vector3
var rot_e: Vector3
var dtc_e: float
var spd_e: float

var _pos: Vector3
var _rot: Vector3
var _dtc: float
var _spd: float

func _enter_tree() -> void:
	instance = self

func _ready() -> void:
	if not camera and get_child_count() > 0:
		camera = get_child(0)

func _process(delta: float) -> void:
	if following and player_node:
		rotation_degrees = rotation_offset
		var base_transform = player_node.position + add_position
		position = position.lerp(base_transform, abs(follow_speed * delta))

func kill_tweens() -> void:
	if do_pos and do_pos.is_running():
		do_pos.kill()
	if do_rot and do_rot.is_running():
		do_rot.kill()
	if do_dis and do_dis.is_running():
		do_dis.kill()
	if do_spe and do_spe.is_running():
		do_spe.kill()

func revive() -> void:
	add_position = _pos
	rotation_offset = _rot
	distance_from_object = _dtc
	follow_speed = _spd
	rotation_degrees = rotation_offset
	var base_transform = player_node.position + add_position
	position = base_transform

func pick() -> void:
	if do_pos == null or not do_pos.is_running():
		_pos = add_position
	else:
		_pos = pos_e
	if do_rot == null or not do_rot.is_running():
		_rot = rotation_offset
	else:
		_rot = rot_e
	if do_dis == null or not do_dis.is_running():
		_dtc = distance_from_object
	else:
		_dtc = dtc_e
	if do_spe == null or not do_spe.is_running():
		_spd = follow_speed
	else:
		_spd = spd_e

func _exit_tree() -> void:
	if instance == self:
		instance = null
