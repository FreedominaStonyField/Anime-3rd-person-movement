extends CharacterBody3D
class_name PlayerController

signal movement_state_changed(state_name: StringName)
signal speed_tier_changed(tier_name: StringName)

@export var walk_speed: float = 3.5
@export var run_speed: float = 6.5
@export var sprint_speed: float = 9.5
@export var acceleration: float = 60.0
@export var deceleration: float = 180.0
@export var air_control: float = 20.0
@export var jump_velocity: float = 5.0
@export var turn_speed: float = 10.0

enum MovementState {
	IDLE,
	WALK,
	RUN,
	SPRINT,
	AIRBORNE
}

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity") as float

var _spawn_transform: Transform3D
var _camera_reference: Node3D
var _movement_state: MovementState = MovementState.IDLE
var _speed_tier: StringName = &"Run"
var _current_speed_value: float = 0.0

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
	_current_speed_value = _determine_speed_tier()

	if input_vector.length_squared() > 0.0:
		var basis := _camera_reference.global_transform.basis if _camera_reference else global_transform.basis
		var forward := -basis.z
		var right := basis.x
		var direction := (forward * input_vector.y) + (right * input_vector.x)
		direction.y = 0.0
		direction = direction.normalized()
		target_velocity = direction * _current_speed_value

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
	_update_movement_state(input_vector)

func reset_to_spawn() -> void:
	global_transform = _spawn_transform
	velocity = Vector3.ZERO
	_update_movement_state(Vector2.ZERO)

func _align_rotation_to_velocity(delta: float) -> void:
	var horizontal_velocity := Vector3(velocity.x, 0.0, velocity.z)
	if horizontal_velocity.length() < 0.05:
		return
	var desired_yaw := atan2(horizontal_velocity.x, horizontal_velocity.z)
	var new_yaw := lerp_angle(rotation.y, desired_yaw, clamp(turn_speed * delta, 0.0, 1.0))
	rotation.y = new_yaw

func _determine_speed_tier() -> float:
	var previous_tier := _speed_tier
	var tier := &"Run"
	var speed := run_speed

	if is_on_floor():
		if Input.is_action_pressed("move_walk"):
			tier = &"Walk"
			speed = walk_speed
		elif Input.is_action_pressed("move_sprint"):
			tier = &"Sprint"
			speed = sprint_speed
	else:
		match previous_tier:
			&"Walk":
				tier = &"Walk"
				speed = walk_speed
			&"Sprint":
				tier = &"Sprint"
				speed = sprint_speed
			_:
				tier = &"Run"
				speed = run_speed

	if tier != previous_tier:
		_speed_tier = tier
		speed_tier_changed.emit(_speed_tier)
	else:
		_speed_tier = tier

	return speed

func _update_movement_state(input_vector: Vector2) -> void:
	var previous_state := _movement_state
	var new_state := _movement_state

	if not is_on_floor():
		new_state = MovementState.AIRBORNE
	else:
		if input_vector.length() < 0.05:
			new_state = MovementState.IDLE
		else:
			match _speed_tier:
				&"Walk":
					new_state = MovementState.WALK
				&"Sprint":
					new_state = MovementState.SPRINT
				_:
					new_state = MovementState.RUN

	if new_state != previous_state:
		_movement_state = new_state
		movement_state_changed.emit(_movement_state_name())
	else:
		_movement_state = new_state

func _movement_state_name() -> StringName:
	match _movement_state:
		MovementState.IDLE:
			return &"Idle"
		MovementState.WALK:
			return &"Walk"
		MovementState.RUN:
			return &"Run"
		MovementState.SPRINT:
			return &"Sprint"
		MovementState.AIRBORNE:
			return &"Airborne"
	return &"Unknown"

func get_speed_tier() -> StringName:
	return _speed_tier

func get_movement_state() -> StringName:
	return _movement_state_name()

func get_debug_metrics() -> Dictionary:
	return {
		"state": _movement_state_name(),
		"speed_tier": _speed_tier,
		"on_floor": is_on_floor()
	}
