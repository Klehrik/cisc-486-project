class_name Path
extends Node3D

## Whether or not to return to the first node after the last one [br]If not, travels backwards along the path
@export var cycle := false

var nodes: Array[Vector3] = []
var current := -1	## [code]-1[/code] so that both [code]get_current()[/code] and [code]get_next()[/code] return the first node

func _ready() -> void:
	# Register path child nodes
	for node: Node3D in get_children():
		nodes.append(node.global_position)
		node.queue_free()

## Returns the current node in the path.
func get_current() -> Vector3:
	if nodes.is_empty():
		return Vector3.INF
	current = max(current, 0)
	return nodes[current]

## Returns the next node in the path and progresses forward.
func get_next() -> Vector3:
	current += 1
	var last := len(nodes) - 1
	if current > last:
		current = 0
		if not cycle:
			nodes.reverse()
			current = min(1, last)
	return nodes[current]

## Resets [code]get_next()[/code] to the closest node to the given position.
func reset_to_nearest_node(position: Vector3) -> void:
	var dist := INF
	for i in range(0, len(nodes)):
		var d := (position - nodes[i]).length_squared()
		if d < dist:
			dist = d
			current = i - 1
