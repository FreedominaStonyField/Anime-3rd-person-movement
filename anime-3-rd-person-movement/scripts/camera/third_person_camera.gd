extends Node3D
class_name ThirdPersonCamera

@export var mouse_sensitivity: float = 0.003
@export var pitch_sensitivity: float = 0.003
@export_range(-80.0, 80.0, 0.1) var min_pitch: float = -60.0
@export_range(-80.0, 80.0, 0.1) var max_pitch: float = 45.0
@export var default_distance: float = 4.5
@export var min_distance: float = 2.0
@export var max_distance: float = 7.0

var target: Node3D

var _yaw: float = 0.0
var _pitch: float = -0.3
var _current_distance: float

@onready var _spring_arm: SpringArm3D = $SpringArm3D

func _ready() -> void:
	_current_distance = clamp(default_distance, min_distance, max_distance)
	_spring_arm.spring_length = _current_distance
	_spring_arm.margin = 0.25
	_apply_rotation()

func set_target(target_node: Node3D) -> void:
	target = target_node
	if target:
		global_transform.origin = target.global_transform.origin
		_apply_rotation()

func _unhandled_input(event: InputEvent) -> void:
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		return
	if event is InputEventMouseMotion:
		var motion := event as InputEventMouseMotion
		_yaw -= motion.relative.x * mouse_sensitivity
		_pitch = clamp(_pitch - motion.relative.y * pitch_sensitivity, deg_to_rad(min_pitch), deg_to_rad(max_pitch))
	elif event is InputEventMouseButton:
		var button := event as InputEventMouseButton
		if button.button_index == MOUSE_BUTTON_WHEEL_UP and button.pressed:
			_adjust_distance(-0.3)
		elif button.button_index == MOUSE_BUTTON_WHEEL_DOWN and button.pressed:
			_adjust_distance(0.3)

func _physics_process(_delta: float) -> void:
	if target:
		global_transform.origin = target.global_transform.origin
	_apply_rotation()
	_spring_arm.spring_length = _current_distance

func _adjust_distance(amount: float) -> void:
	_current_distance = clamp(_current_distance + amount, min_distance, max_distance)

func _apply_rotation() -> void:
	var rotation_basis := Basis(Vector3.UP, _yaw) * Basis(Vector3(1, 0, 0), _pitch)
	global_transform = Transform3D(rotation_basis, global_transform.origin)
