extends Node

const hitbox = preload("res://src/entities/hitbox.tscn")

var inst: Node3D

## Instantiates the scene in global world space.
func instantiate_global(scene: PackedScene) -> Node:
	var c := scene.instantiate()
	if not inst:
		inst = get_tree().current_scene.find_child("Instantiated")
	inst.add_child(c)
	return c
