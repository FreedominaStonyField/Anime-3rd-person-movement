extends CanvasLayer
class_name DebugHUD

signal reset_requested

@onready var _reset_button: Button = $ResetButton
@onready var _position_label: Label = $PositionLabel

func _ready() -> void:
	_reset_button.pressed.connect(func() -> void:
		reset_requested.emit()
	)
	set_reset_button_visible(false)

func update_position(world_position: Vector3) -> void:
	var display := Vector3(snapped(world_position.x, 0.01), snapped(world_position.y, 0.01), snapped(world_position.z, 0.01))
	_position_label.text = "Pos: " + str(display)

func set_reset_button_visible(visible: bool) -> void:
	_reset_button.visible = visible
	_reset_button.disabled = not visible
	if not visible:
		_reset_button.release_focus()
