class_name DialogueArrow
extends Sprite2D

const y_speed_scale := 0.02
const y_offset 	    := 2.0

@onready var y_start := position.y

func _process(delta: float) -> void:
	position.y = y_start + (cos(Game.frame * y_speed_scale) * y_offset)
