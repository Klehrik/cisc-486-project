class_name Chunk
extends Node3D

func _ready() -> void:
	# Enable walls
	# TODO only enable if another chunk is not connecting
	var walls: Node3D = $Walls
	walls.visible = true
	walls.process_mode = Node.PROCESS_MODE_INHERIT
