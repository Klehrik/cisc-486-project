class_name Music
extends Node3D

const NORMAL = -5.0
const MUTED  = -40.0

static var instance: Music

var track1: AudioStreamPlayer
var track2: AudioStreamPlayer

var tween: Tween

func _ready() -> void:
	assert(not instance, "Music singleton already exists.")
	instance = self
	track1 = $Track1
	track2 = $Track2
	track1.play()
	track2.play()
	crossfade(NORMAL, MUTED, 3.0)

static func crossfade(vol1: float, vol2: float, time: float) -> void:
	if not instance:
		return
	if instance.tween:
		instance.tween.stop()
	instance.tween = instance.create_tween()
	instance.tween.set_parallel()
	instance.tween.tween_property(instance.track1, "volume_db", vol1, time * abs(vol1)/3.0)
	instance.tween.tween_property(instance.track2, "volume_db", vol2, time * abs(vol2)/3.0)
