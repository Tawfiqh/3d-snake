extends CharacterBody3D


const SPEED = 15.0
const STEERING_POWER = 2.0


func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if input_dir:
		rotation -= Vector3(input_dir.y, input_dir.x, 0) * STEERING_POWER * delta
	velocity = global_transform.basis.z * SPEED
	
	move_and_slide()
	var collision: KinematicCollision3D = get_last_slide_collision()
	if collision:
		handle_collision(collision)


# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Collision Detection
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# const HIT_LAYER_FILTER := (1 << 1) | (1 << 2) # layers 2 and 3
func handle_collision(collision: KinematicCollision3D) -> void:
	var collider = collision.get_collider()
	print("Collision detected with: ", collision.get_collider().name)
	Game.game_over()
