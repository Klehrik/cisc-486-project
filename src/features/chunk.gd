class_name Chunk
extends Node3D

const chunk_size := 24.0

func _ready() -> void:
	# Enable walls
	var border_walls: Node3D = $BorderWalls
	border_walls.visible = true
	border_walls.process_mode = Node.PROCESS_MODE_INHERIT
	for sb: StaticBody3D in border_walls.get_children():
		sb.collision_layer = 1

	# Disable walls that have a connecting chunk
	var walls := [
		[$BorderWalls/Back,  Vector3.BACK],
		[$BorderWalls/Front, Vector3.FORWARD],
		[$BorderWalls/Left,  Vector3.LEFT],
		[$BorderWalls/Right, Vector3.RIGHT],
	]
	var chunks: Array[Node] = get_tree().get_nodes_in_group("Chunk")
	
	for w in walls:
		var sb: StaticBody3D = w[0]
		var dir: Vector3	 = w[1]
		
		# Check if any other chunks are in dir position
		var position_relative = position + (dir * chunk_size)
		var has := false
		for chunk: Chunk in chunks:
			if chunk == self:
				continue
			if (position_relative - chunk.global_position).length() < 1.0:
				has = true
				break
		if has:
			sb.visible = false
			sb.process_mode = Node.PROCESS_MODE_DISABLED
