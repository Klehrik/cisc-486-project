class_name HUDHealth
extends Node2D

static var instance: HUDHealth

const bar_width 		:= 50
const white_tween_delay := 1.5	## How long the white stays before dissipating.
const white_tween_time  := 1.0	## How long the white takes to dissipate.

var hurtbox: Hurtbox
var prev_health: float
var white_tween: Tween
var white_tween_value: float

@onready var bar_max: ColorRect 		= $Max
@onready var bar_current: ColorRect 	= $Current
@onready var bar_recoverable: ColorRect = $Recoverable
@onready var bar_white: ColorRect 		= $White

func _ready() -> void:
	assert(not instance, "HUDHealth singleton already exists.")
	instance = self

func _process(delta: float) -> void:
	if not hurtbox:
		return
	
	var ratio := hurtbox.health / hurtbox.health_max
	bar_current.size.x = ratio * bar_width
	
	var diff = prev_health - hurtbox.health
	if diff > 0:
		white_tween_value += diff
		
		# Recoverable part of bar
		bar_recoverable.position.x = bar_current.size.x
		bar_recoverable.size.x = hurtbox.recoverable_health / hurtbox.health_max * bar_width
		if hurtbox.health <= 0:
			bar_recoverable.size.x = 0
		
		# White part of bar (damage taken)
		bar_white.position.x = bar_current.size.x
		bar_white.size.x = white_tween_value / hurtbox.health_max * bar_width
		
		if white_tween:
			white_tween.stop()
		white_tween = create_tween()
		white_tween.set_ease(Tween.EASE_OUT)
		white_tween.set_trans(Tween.TRANS_CUBIC)
		white_tween.tween_interval(white_tween_delay)
		white_tween.tween_property(bar_white, "size:x", 0.0, white_tween_time)
		white_tween.parallel()
		white_tween.tween_property(self, "white_tween_value", 0.0, white_tween_time)
	
	# Do not adjust bars on passive health recovery
	if diff < -hurtbox.recover_speed * delta * 3:
		bar_recoverable.position.x = bar_current.size.x
		bar_recoverable.size.x = hurtbox.recoverable_health / hurtbox.health_max * bar_width
		
		# TODO: actually readjust white bar
		# when healing instead of ending it
		white_tween_value = 0
		bar_white.size.x = 0
		if white_tween:
			white_tween.stop()
		
	prev_health = hurtbox.health
