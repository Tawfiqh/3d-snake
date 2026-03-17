extends Node3D

var _game_over_layer: CanvasLayer
var _paused: bool = false
var _paused_overlay_layer: ColorRect

var moving = true
var trail_length = 90
const GAME_BOX_SIZE = 50.0
var SCORE = 0
const SPAWN_RADIUS = (GAME_BOX_SIZE - 20) / 2
const SNAKE_GIRTH = 20.0
const fruit_scene: PackedScene = preload("res://fruit.tscn")
const INITIAL_SPEED = 6.0
const SPEED_INCREMENT = 10.0

func _ready():
	new_game()

func game_over() -> void:
	print("Game over")
	moving = false
	_show_game_over_overlay()


func _show_game_over_overlay() -> void:
	if _game_over_layer:
		print("Showing game over overlay..")
		_game_over_layer.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func new_game():
	moving = true
	spawn_fruit()

func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()
	print("Game scene reloaded")


func _on_pause_button_pressed() -> void:
	if !_paused:
		_pause_game()
	else:
		_resume_game()


func _pause_game() -> void:
	print("Pausing game")
	_paused = true
	moving = false
	if _paused_overlay_layer:
		_paused_overlay_layer.visible = true

		
func _resume_game() -> void:
	_paused = false
	moving = true
	if _paused_overlay_layer:
		_paused_overlay_layer.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if not _game_over_layer or not _game_over_layer.visible:
		return
	if event.is_action_pressed("ui_accept"):
		_on_restart_pressed()

func spawn_fruit():
	print("spawning fruit")
	var fruit_pos = Vector3(randf_range(SPAWN_RADIUS, -SPAWN_RADIUS), randf_range(SPAWN_RADIUS, -SPAWN_RADIUS), randf_range(SPAWN_RADIUS, -SPAWN_RADIUS))
	var new_fruit = fruit_scene.instantiate()
	new_fruit.position = fruit_pos
	get_tree().current_scene.add_child(new_fruit)
