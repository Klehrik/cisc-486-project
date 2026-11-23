class_name WorldPopup
extends Marker3D

@export_multiline var text: String
@export var PoI_range := 6.0	## In metres.

var label: WorldLabel

func _ready() -> void:
	global_position += Vector3.UP
	
	label = WorldLabel.create()
	add_child(PoI.new(-1, -1, PoI_range))

func _physics_process(delta: float) -> void:
	label.text = text
	label.position_3d = global_position
