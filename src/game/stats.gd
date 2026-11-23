class_name Stats
extends Node

static var time_taken: float
static var enemies_alerted: int
static var enemies_killed: int
static var damage_taken: float

static func reset() -> void:
	time_taken		= -2.0	## Accounts for intro fade-in
	enemies_alerted = 0
	enemies_killed  = 0
	damage_taken	= 0.0
