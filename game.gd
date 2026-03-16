extends Node3D

@onready var _game_over_layer: CanvasLayer


func game_over() -> void:
	print("Game over")
	_show_game_over_overlay()


func _show_game_over_overlay() -> void:
	if _game_over_layer:
		print("Showing game over overlay..")
		_game_over_layer.visible = true


func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()
	print("Game scene reloaded")
