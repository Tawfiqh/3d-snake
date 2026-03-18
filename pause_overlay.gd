extends ColorRect

@onready var pauseButton = $"../PauseButton"
@onready var invertYCheckButton: CheckButton = $InvertYCheckButton
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Pause overlay layer ready..")
	Game._paused_overlay_layer = self
	invertYCheckButton.button_pressed = Game.invert_y_axis


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_pause_button_pressed() -> void:
	Game._on_pause_button_pressed()
	if Game._paused:
		pauseButton.text = "Resume"
	else:
		pauseButton.text = "Pause"


func _on_invert_y_check_button_toggled(toggled_on: bool) -> void:
	Game.invert_y_axis = toggled_on
