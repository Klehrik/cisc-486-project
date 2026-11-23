class_name Fade
extends ColorRect

signal tween_done()	## Emitted when a tween finishes.

static var instance: Fade

var fade: float:	## Current fade (0.0 to 1.0).
	get():
		return fade
	set(value):
		fade = clamp(value, 0.0, 1.0)
		(material as ShaderMaterial).set_shader_parameter("fade", fade)
var tween: Tween

func _ready() -> void:
	assert(not instance, "Fade singleton already exists.")
	instance = self
	fade = 1.0
	tween_to_value(0.0, 2.0)

func tween_to_value(value: float, time: float) -> void:
	if tween:
		tween.stop()
	tween = create_tween()
	tween.tween_property(self, "fade", value, time)
	await tween.finished
	tween_done.emit()
