class_name DialogueArrow
extends Sprite2D

const y_speed_scale := 0.02
const y_offset 	    := 2.0

var game_frame := 0

@onready var y_start := position.y

func _physics_process(delta: float) -> void:
	game_frame += 1
	position.y = y_start + (cos(game_frame * y_speed_scale) * y_offset)
