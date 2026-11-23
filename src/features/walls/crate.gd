extends StaticBody3D

func _ready() -> void:
	await get_tree().process_frame

	# Replace CSG with MeshInstance
	var csg: CSGBox3D = $CSGBox3D
	var baked: ArrayMesh = csg.bake_static_mesh()
	var mesh_instance := MeshInstance3D.new()
	add_child(mesh_instance)
	mesh_instance.mesh = baked
	mesh_instance.global_transform = csg.global_transform
	mesh_instance.material_override = csg.material_override
	csg.queue_free()
