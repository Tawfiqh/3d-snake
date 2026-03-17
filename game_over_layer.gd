extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Game over layer ready..")
	Game._game_over_layer = self
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_restart_pressed() -> void:
	Game._on_restart_pressed()
