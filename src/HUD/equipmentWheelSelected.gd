class_name EquipmentWheelSelected
extends Node2D

var segments  := 32
var radius    := 120

var ratio := 1.0:	## The ratio of filled-in circle (from 0.0 to 1.0). [br]This can be set to update it.
	get():
		return ratio
	set(value):
		ratio = clamp(value, 0.0, 1.0)
		end_angle = -PI/2 + (PI * 1.9999 * ratio)
var end_angle: float

func _process(delta: float) -> void:
	queue_redraw()
	
func _draw() -> void:
	var points := [Vector2.ZERO]
	for i in range(segments + 1):
		var t := float(i) / segments
		var angle: float = lerp(-PI/2, end_angle, t)
		points.append(Vector2.from_angle(angle) * radius)
	draw_polygon(points, [Color.WHITE])
