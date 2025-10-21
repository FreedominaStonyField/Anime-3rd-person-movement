extends CanvasLayer
class_name DebugOverlay

signal reset_requested

@onready var _metrics_panel: Panel = $MetricsPanel
@onready var _state_value: Label = $MetricsPanel/Margin/VBox/Grid/StateValue
@onready var _tier_value: Label = $MetricsPanel/Margin/VBox/Grid/SpeedTierValue
@onready var _grounded_value: Label = $MetricsPanel/Margin/VBox/Grid/GroundedValue

@onready var _reset_button: Button = $ResetButton
@onready var _position_label: Label = $PositionLabel

var _player: PlayerController = null

func _ready() -> void:
	_metrics_panel.visible = false
	set_reset_button_visible(false)
	_reset_button.pressed.connect(func() -> void:
		reset_requested.emit()
	)

func set_player(player: PlayerController) -> void:
	if _player:
		if _player.movement_state_changed.is_connected(_on_state_changed):
			_player.movement_state_changed.disconnect(_on_state_changed)
		if _player.speed_tier_changed.is_connected(_on_speed_tier_changed):
			_player.speed_tier_changed.disconnect(_on_speed_tier_changed)
	_player = player
	if _player:
		_player.movement_state_changed.connect(_on_state_changed)
		_player.speed_tier_changed.connect(_on_speed_tier_changed)
		_refresh_metrics()

func update_position(world_position: Vector3) -> void:
	var display: Vector3 = Vector3(
		snapped(world_position.x, 0.01),
		snapped(world_position.y, 0.01),
		snapped(world_position.z, 0.01)
	)
	_position_label.text = "Pos: {0}".format([display])

func set_reset_button_visible(visible: bool) -> void:
	_reset_button.visible = visible
	_reset_button.disabled = not visible
	if not visible:
		_reset_button.release_focus()

func toggle_metrics() -> void:
	_metrics_panel.visible = not _metrics_panel.visible
	if _metrics_panel.visible:
		_refresh_metrics()

func hide_metrics() -> void:
	if _metrics_panel.visible:
		_metrics_panel.visible = false

func _process(_delta: float) -> void:
	if _metrics_panel.visible:
		_refresh_metrics()

func _refresh_metrics() -> void:
	if not _player:
		return
	var metrics: Dictionary = _player.get_debug_metrics()
	_state_value.text = str(metrics.get("state", "Unknown"))
	_tier_value.text = str(metrics.get("speed_tier", "Run"))
	var grounded: bool = bool(metrics.get("on_floor", false))
	_grounded_value.text = "Yes" if grounded else "No"

func _on_state_changed(_state: StringName) -> void:
	if _metrics_panel.visible:
		_refresh_metrics()

func _on_speed_tier_changed(_tier: StringName) -> void:
	if _metrics_panel.visible:
		_refresh_metrics()
