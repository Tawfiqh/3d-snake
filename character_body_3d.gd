extends CharacterBody3D


const SPEED = 5.0
const STEERING_POWER = 2.0


func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if input_dir:
		rotation -= Vector3(input_dir.y, input_dir.x, 0)*STEERING_POWER*delta
	velocity = global_transform.basis.z*SPEED
	
	move_and_slide()
