extends CharacterBody3D
class_name Player

@export var trailScene: PackedScene

const SPEED = 5.0
const STEERING_POWER = 2.0
const TRAIL_REFRESH_RATE: int = 1

var frame_count: int = 0

const TRAIL_OFFSET: float = 0.3
var trail_segments = []

func _ready():
	print("player ready")
	Game.moving = true

func generate_trail() -> void:
	if not Game.moving: return

	# Create a new trail segment at the current position
	var trail_segment = trailScene.instantiate()
	# var local_position = position #- (Vector3(0, 0, 1) * TRAIL_OFFSET)
	# trail_segment.global_position = to_global(local_position)
	trail_segment.position = position - global_transform.basis.z*TRAIL_OFFSET
	trail_segment.rotation = rotation

	# Add the trail segment to the trail array
	get_parent().add_child(trail_segment)
	trail_segments.append(trail_segment)

	# Update the trail array - and remove any segments that are too old
	if(trail_segments.size() > Game.trail_length):
		var segment_to_remove : Node3D = trail_segments.pop_front()
		segment_to_remove.hide()
		segment_to_remove.queue_free()

	pass



# This is called on every physics tick
func _physics_process(delta: float) -> void:
	# print(Game.moving)
	if not Game.moving: return
	frame_count += 1
	if frame_count % TRAIL_REFRESH_RATE == 0:
		generate_trail()
		frame_count = 0
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if input_dir:
		rotation -= Vector3(input_dir.y, input_dir.x, 0) * STEERING_POWER * delta
	velocity = global_transform.basis.z * SPEED
	move_and_slide()


# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Collision Detection
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-


func _on_tongue_body_entered(body: Node3D) -> void:
	print("ouch!")
	Game.game_over()
func _on_tongue_area_entered(body: Node3D) -> void:
	print("ouch!")
	Game.game_over()