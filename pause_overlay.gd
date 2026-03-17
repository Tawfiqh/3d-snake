extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Pause overlay layer ready..")
	Game._paused_overlay_layer = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
