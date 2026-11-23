class_name Stats
extends Node

static var time_taken: float
static var enemies_alerted: int
static var enemies_killed: int

func reset() -> void:
	time_taken		= 0.0
	enemies_alerted = 0
	enemies_killed  = 0
