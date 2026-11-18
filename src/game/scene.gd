extends Node

const hitbox = preload("res://src/entities/hitbox.tscn")
const world_label = preload("res://src/game/worldLabel/worldLabel.tscn")
const projectile = preload("res://src/entities/projectile/projectile.tscn")

var tree: Node
var inst: Node3D

## Instantiates the scene in global world space. [br]
## [code]path[/code] is the path from the world root node; places it under Instantiated by default.
func instantiate_global(scene: PackedScene, path: String = "") -> Node:
	if not tree:
		tree = get_tree().current_scene
	if not inst:
		inst = tree.get_node("Instantiated")
	
	var parent = inst
	if path:
		var n := tree.get_node_or_null(path)
		if n:
			parent = n
	
	var c := scene.instantiate()
	parent.add_child(c)
	return c
