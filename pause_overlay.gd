extends ColorRect

@onready var pauseButton = $"../PauseButton"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Pause overlay layer ready..")
	Game._paused_overlay_layer = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pause_button_pressed() -> void:
	Game._on_pause_button_pressed()
	if Game._paused:
		pauseButton.text = "Resume"
	else:
		pauseButton.text = "Pause"
