extends Node3D

@export var fall_reset_height: float = -20.0

@onready var _player: PlayerController = $Player
@onready var _reset_button: Button = $CanvasLayer/ResetButton
@onready var _position_label: Label = $CanvasLayer/PositionLabel

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	_reset_button.pressed.connect(_on_reset_button_pressed)
	_update_position_label()

func _process(_delta: float) -> void:
	if _player.global_position.y < fall_reset_height:
		_player.reset_to_spawn()
	_update_position_label()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		var new_mode := Input.MOUSE_MODE_VISIBLE if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED else Input.MOUSE_MODE_CAPTURED
		Input.set_mouse_mode(new_mode)

func _on_reset_button_pressed() -> void:
	_player.reset_to_spawn()
	_update_position_label()

func _update_position_label() -> void:
	var pos := _player.global_position
	var display := Vector3(snapped(pos.x, 0.01), snapped(pos.y, 0.01), snapped(pos.z, 0.01))
	_position_label.text = "Pos: " + str(display)
