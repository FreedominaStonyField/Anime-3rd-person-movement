extends CharacterBody3D
class_name PlayerController

@export var move_speed: float = 8.0
@export var acceleration: float = 60.0
@export var deceleration: float = 180.0
@export var air_control: float = 20.0
@export var jump_velocity: float = 5.0
@export var turn_speed: float = 10.0

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity") as float

var _spawn_transform: Transform3D
var _camera_reference: Node3D

@onready var _camera_target: Node3D = $CameraTarget

func _ready() -> void:
	_spawn_transform = global_transform

func set_camera(camera_node: Node3D) -> void:
	_camera_reference = camera_node

func get_camera_target() -> Node3D:
	return _camera_target

func _physics_process(delta: float) -> void:
	var input_vector := Input.get_vector("move_left", "move_right", "move_back", "move_forward")
	var target_velocity := Vector3.ZERO

	if input_vector.length_squared() > 0.0:
		var basis := _camera_reference.global_transform.basis if _camera_reference else global_transform.basis
		var forward := -basis.z
		var right := basis.x
		var direction := (forward * input_vector.y) + (right * input_vector.x)
		direction.y = 0.0
		direction = direction.normalized()
		target_velocity = direction * move_speed

	if target_velocity != Vector3.ZERO:
		var accel_rate := acceleration if is_on_floor() else air_control
		velocity.x = move_toward(velocity.x, target_velocity.x, accel_rate * delta)
		velocity.z = move_toward(velocity.z, target_velocity.z, accel_rate * delta)
	else:
		var decel_rate := deceleration if is_on_floor() else air_control
		velocity.x = move_toward(velocity.x, 0.0, decel_rate * delta)
		velocity.z = move_toward(velocity.z, 0.0, decel_rate * delta)
		if is_on_floor():
			if abs(velocity.x) < 0.05:
				velocity.x = 0.0
			if abs(velocity.z) < 0.05:
				velocity.z = 0.0

	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_velocity
		elif velocity.y < 0.0:
			velocity.y = 0.0
	else:
		velocity.y -= gravity * delta

	move_and_slide()
	_align_rotation_to_velocity(delta)

func reset_to_spawn() -> void:
	global_transform = _spawn_transform
	velocity = Vector3.ZERO

func _align_rotation_to_velocity(delta: float) -> void:
	var horizontal_velocity := Vector3(velocity.x, 0.0, velocity.z)
	if horizontal_velocity.length() < 0.05:
		return
	var desired_yaw := atan2(horizontal_velocity.x, horizontal_velocity.z)
	var new_yaw := lerp_angle(rotation.y, desired_yaw, clamp(turn_speed * delta, 0.0, 1.0))
	rotation.y = new_yaw
