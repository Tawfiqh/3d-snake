extends Control

const MOBILE_FEATURE_NAME := "mobile"

var _action_by_button: Dictionary = {}
var _touch_device_available: bool = false


func _ready() -> void:
	_touch_device_available = OS.has_feature(MOBILE_FEATURE_NAME) or DisplayServer.is_touchscreen_available()
	visible = _touch_device_available and Game.moving
	_bind_button_actions()


func _process(_delta: float) -> void:
	var should_show := _touch_device_available and Game.moving
	if visible != should_show:
		visible = should_show
		if not visible:
			_release_all_actions()


func _exit_tree() -> void:
	_release_all_actions()


func _bind_button_actions() -> void:
	_register_button($"DPad/Up", "ui_up")
	_register_button($"DPad/Left", "ui_left")
	_register_button($"DPad/Right", "ui_right")
	_register_button($"DPad/Down", "ui_down")
	_register_button($Boost, "ui_boost")


func _register_button(button: Button, action_name: StringName) -> void:
	_action_by_button[button] = action_name
	button.button_down.connect(_on_button_down.bind(button))
	button.button_up.connect(_on_button_up.bind(button))


func _on_button_down(button: Button) -> void:
	var action_name: StringName = _action_by_button.get(button, &"")
	if action_name != &"":
		Input.action_press(action_name)


func _on_button_up(button: Button) -> void:
	var action_name: StringName = _action_by_button.get(button, &"")
	if action_name != &"":
		Input.action_release(action_name)


func _release_all_actions() -> void:
	for action_name in _action_by_button.values():
		Input.action_release(action_name)
