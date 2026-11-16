class_name WorldLabel
extends Node2D

var text: String:
	get():
		return label.text
	set(value):
		label.text = value
var size := 1.0:
	get():
		return size
	set(value):
		size = value
		label.add_theme_font_size_override("normal_font_size", int(base_size * value))
var color: Color:
	get():
		return label.modulate
	set(value):
		label.modulate = value
var alpha: float:
	get():
		return label.modulate.a
	set(value):
		label.modulate.a = value
var position_3d: Vector3:	## The position of the label in 3D world space. [br]Automatically places it in the correct position on screen.
	get():
		return position_3d
	set(value):
		position_3d = value
		position = Camera.instance.unproject_position(value)

@onready var label: RichTextLabel = $Label
@onready var base_size: float = label.get_theme_font_size("normal_font_size")

## Creates a new world label.
static func create() -> WorldLabel:
	var inst: WorldLabel = Scene.instantiate_global(Scene.world_label, "Screen")
	return inst
