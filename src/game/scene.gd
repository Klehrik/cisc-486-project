extends Node

const hitbox 		:= preload("res://src/entities/hitbox.tscn")
const world_label 	:= preload("res://src/game/worldLabel/worldLabel.tscn")
const projectile 	:= preload("res://src/entities/projectile/projectile.tscn")
const popup 		:= preload("res://src/HUD/popup/popup.tscn")

var tree: Node
var inst: Node3D

## Instantiates the scene in global world space. [br]
## [code]path[/code] is the path from the world root node; places it under Instantiated by default.
func instantiate_global(scene: PackedScene, path: String = "") -> Node:
	if not _setup():
		push_warning("Tree not initialzed yet.")
		return
	
	var parent = inst
	if path:
		var n := tree.get_node_or_null(path)
		if n:
			parent = n
	
	var c := scene.instantiate()
	parent.add_child(c)
	return c

## Adds a node to the tree. [br]
## [code]path[/code] is the path from the world root node; places it under Instantiated by default.
func add_to_tree(node: Node, path: String = "") -> void:
	if not _setup():
		push_warning("Tree not initialzed yet.")
		return
	
	var parent = inst
	if path:
		var n := tree.get_node_or_null(path)
		if n:
			parent = n
	
	parent.add_child(node)

func _setup() -> bool:
	if not tree:
		var t := get_tree()
		if t:
			tree = t.current_scene
		else:
			return false
	if not inst:
		inst = tree.get_node("Instantiated")
	return true
