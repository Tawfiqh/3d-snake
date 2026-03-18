extends CharacterBody3D
class_name Player

@export var trailScene: PackedScene

var SPEED = Game.INITIAL_SPEED
const STEERING_POWER = 5.0
const TRAIL_REFRESH_RATE: int = 1

var frame_count: int = 0
var mouse_sensitivity := 0.02
var mouse_turn_input := Vector2.ZERO
const MOBILE_FEATURE_NAME := "mobile"

const TRAIL_OFFSET: float = 0.3
var SNAKE_SCALE = Vector3(Game.SNAKE_GIRTH / 10, Game.SNAKE_GIRTH / 10, Game.SNAKE_GIRTH / 10)
var trail_segments = []

func _ready():
	print("player ready")
	Game.moving = true
	scale = SNAKE_SCALE
	_capture_mouse_onload()


func _process(_delta: float) -> void:
	_update_mouse_mode()
	_process_boost(_delta)

# This is called on every physics tick
func _physics_process(delta: float) -> void:
	if not Game.moving:
		return

	frame_count += 1
	if frame_count % TRAIL_REFRESH_RATE == 0:
		generate_trail()
		frame_count = 0


	# Blend keyboard steering with mouse steering.
	var keyboard_input := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var steer_input := keyboard_input + mouse_turn_input

	if steer_input.length() > 1.0:
		steer_input = steer_input.normalized()
	if steer_input != Vector2.ZERO:
		# rotation -= Vector3(steer_input.y, steer_input.x, 0) * STEERING_POWER * delta
		_apply_local_steering(steer_input, delta)
	mouse_turn_input = Vector2.ZERO
	velocity = global_transform.basis.z * SPEED
	move_and_slide()

	if get_last_slide_collision():
		Game.game_over()


func _apply_local_steering(steer_input: Vector2, delta: float) -> void:
	var effective_y_input := steer_input.y
	if Game.invert_y_axis:
		effective_y_input *= -1.0
	var pitch_amount := -effective_y_input * STEERING_POWER * delta
	var yaw_amount := -steer_input.x * STEERING_POWER * delta
	rotate_object_local(Vector3.RIGHT, pitch_amount)
	rotate_object_local(Vector3.UP, yaw_amount)

# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Generating the trail
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

func generate_trail() -> void:
	if not Game.moving: return

	# Create a new trail segment at the current position
	var trail_segment = trailScene.instantiate()
	# var local_position = position #- (Vector3(0, 0, 1) * TRAIL_OFFSET)
	# trail_segment.global_position = to_global(local_position)
	trail_segment.scale = SNAKE_SCALE
	trail_segment.position = position - global_transform.basis.z * TRAIL_OFFSET
	trail_segment.rotation = rotation

	# Add the trail segment to the trail array
	get_parent().add_child(trail_segment)
	trail_segments.append(trail_segment)

	# Update the trail array - and remove any segments that are too old
	if (trail_segments.size() > Game.trail_length):
		var segment_to_remove: Node3D = trail_segments.pop_front()
		segment_to_remove.hide()
		segment_to_remove.queue_free()

	pass


# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Processing the boost
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

func _process_boost(delta: float) -> void:
	if Input.is_action_pressed("ui_boost"):
		SPEED += Game.SPEED_INCREMENT * delta
		Game.SCORE += Game.SPEED_INCREMENT * delta
		print("Boosted! Speed: ", SPEED)
	else:
		SPEED = 6.0

# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Collision Detection
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

func _on_tongue_body_entered(body: Node3D) -> void:
	print("ouch!")
	Game.game_over()
func _on_tongue_area_entered(body: Node3D) -> void:
	print("ouch!")
	Game.game_over()


# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Mouse inputs
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

func _capture_mouse_onload() -> void:
	if OS.has_feature(MOBILE_FEATURE_NAME):
		return
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _update_mouse_mode() -> void:
	if OS.has_feature(MOBILE_FEATURE_NAME):
		return
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			mouse_turn_input = event.relative * mouse_sensitivity
			mouse_turn_input = mouse_turn_input.limit_length(1.0)
