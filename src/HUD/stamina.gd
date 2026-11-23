class_name HUDStamina
extends Node2D

static var instance: HUDStamina

const bar_width := 50

var player: Player	# :broken_heart:

@onready var bar: ColorRect = $Bar

func _ready() -> void:
	assert(not instance, "HUDStamina singleton already exists.")
	instance = self

func _process(delta: float) -> void:
	if not player:
		return
		
	var ratio := player.stamina / player.stamina_max
	bar.size.x = ratio * bar_width
