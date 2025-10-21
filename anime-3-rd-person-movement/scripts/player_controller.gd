extends CharacterBody3D
class_name PlayerController

@export var move_speed: float = 8.0
@export var acceleration: float = 10.0
@export var air_control: float = 4.0
@export var jump_velocity: float = 5.0
@export var mouse_sensitivity: float = 0.003
@export var max_look_angle: float = 75.0

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity") as float

var _spawn_transform: Transform3D
var _spawn_yaw: float
var _spawn_pitch: float
var _yaw: float
var _pitch: float

@onready var _camera_pivot: Node3D = $CameraPivot
@onready var _spring_arm: SpringArm3D = $CameraPivot/SpringArm3D
@onready var _camera: Camera3D = $CameraPivot/SpringArm3D/Camera3D

func _ready() -> void:
	_spawn_transform = global_transform
	_spawn_yaw = rotation.y
	_spawn_pitch = _camera_pivot.rotation.x
	_yaw = _spawn_yaw
	_pitch = clamp(_spawn_pitch, deg_to_rad(-max_look_angle), deg_to_rad(max_look_angle))
	rotation.y = _yaw
	_camera_pivot.rotation.x = _pitch

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		var motion := event as InputEventMouseMotion
		_yaw -= motion.relative.x * mouse_sensitivity
		_pitch = clamp(_pitch - motion.relative.y * mouse_sensitivity, deg_to_rad(-max_look_angle), deg_to_rad(max_look_angle))
		rotation.y = _yaw
		_camera_pivot.rotation.x = _pitch

func _physics_process(delta: float) -> void:
	var input_vector := Input.get_vector("move_left", "move_right", "move_back", "move_forward")
	var target_velocity := Vector3.ZERO

	if input_vector.length_squared() > 0.0:
		var forward := -_camera.global_transform.basis.z
		var right := _camera.global_transform.basis.x
		var direction := (forward * input_vector.y) + (right * input_vector.x)
		direction.y = 0.0
		direction = direction.normalized()
		target_velocity = direction * move_speed

	var accel := acceleration if is_on_floor() else air_control
	velocity.x = move_toward(velocity.x, target_velocity.x, accel * delta)
	velocity.z = move_toward(velocity.z, target_velocity.z, accel * delta)

	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_velocity
		elif velocity.y < 0.0:
			velocity.y = 0.0
	else:
		velocity.y -= gravity * delta

	move_and_slide()

func reset_to_spawn() -> void:
	global_transform = _spawn_transform
	velocity = Vector3.ZERO
	_yaw = _spawn_yaw
	_pitch = clamp(_spawn_pitch, deg_to_rad(-max_look_angle), deg_to_rad(max_look_angle))
	rotation.y = _yaw
	_camera_pivot.rotation.x = _pitch
