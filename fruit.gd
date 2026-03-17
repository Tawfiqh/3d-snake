extends Node3D

const SIZE_INCREASE = 50
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func eat_fruit():
	print("eaten!")
	Game.SCORE += 10
	Game.trail_length += SIZE_INCREASE
	Game.spawn_fruit()
	queue_free()

func _on_area_3d_body_entered(body: Node3D) -> void:
	print("body entered fruit -- body: ", body.name)
	eat_fruit()


func _on_area_3d_area_entered(area: Area3D) -> void:
	print("area entered fruit -- area: ", area.name)
	eat_fruit()
