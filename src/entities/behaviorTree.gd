class_name BehaviorTree
extends Node

var tree: Array = []

"""
Format:

BehaviorTree.new([
	"?",
	leaf1,
	[
		"?",
		leaf2,
		leaf3,
		[
			">",
			leaf4,
			[
				"?",
				leaf5,
				leaf6
			],
			leaf7
		]
	]
])
"""

func _init(tree: Array) -> void:
	self.tree = tree

func tick(tree: Array = tree) -> bool:
	if len(tree) > 0:
		match tree[0]:
			"?":
				for i in range(1, len(tree)):
					var node = tree[i]
					if node is Callable:
						var status: bool = node.call()
						if status:
							return true
					elif node is Array:
						var status: bool = tick(node)
						if status:
							return true
				return false
			">":
				for i in range(1, len(tree)):
					var node = tree[i]
					if node is Callable:
						var status: bool = node.call()
						if not status:
							return false
					elif node is Array:
						var status: bool = tick(node)
						if not status:
							return false
				return true
	return false
