extends StaticBody3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var mesh_node : MeshInstance3D = $mesh
	mesh_node.mesh.size.x = Game.GAME_BOX_SIZE
	mesh_node.mesh.size.y = Game.GAME_BOX_SIZE
	mesh_node.mesh.size.z = Game.GAME_BOX_SIZE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
