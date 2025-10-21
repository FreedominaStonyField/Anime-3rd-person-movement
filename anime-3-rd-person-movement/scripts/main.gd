extends Node3D

@export var fall_reset_height: float = -20.0

@onready var _player: PlayerController = $Player
@onready var _camera_rig: ThirdPersonCamera = $ThirdPersonCamera
@onready var _debug_hud: DebugHUD = $DebugHUD

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	_camera_rig.set_target(_player.get_camera_target())
	_player.set_camera(_camera_rig)
	_debug_hud.reset_requested.connect(_on_reset_requested)
	_debug_hud.update_position(_player.global_position)

func _process(_delta: float) -> void:
	if _player.global_position.y < fall_reset_height:
		_reset_player()
	else:
		_debug_hud.update_position(_player.global_position)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		var new_mode := Input.MOUSE_MODE_VISIBLE if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED else Input.MOUSE_MODE_CAPTURED
		Input.set_mouse_mode(new_mode)

func _on_reset_requested() -> void:
	_reset_player()

func _reset_player() -> void:
	_player.reset_to_spawn()
	_debug_hud.update_position(_player.global_position)
