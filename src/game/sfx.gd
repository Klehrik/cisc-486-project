class_name SFX
extends Node3D

static var instance: SFX

var sfx: Dictionary[String, AudioStreamPlayer3D] = {}

func _ready() -> void:
	assert(not instance, "SFX singleton already exists.")
	instance = self

	# Register SFX child nodes
	for s: AudioStreamPlayer3D in get_children():
		sfx[s.name] = s

## Play a sound at a global position.
static func play(name: String, pos: Vector3) -> void:
	if not instance:
		return
	
	var s: AudioStreamPlayer3D = instance.sfx.get(name)
	assert(s, "SFX '%s' does not exist." % name)
	
	# Duplicate node and play at position
	var s2 := s.duplicate()
	instance.add_child(s2)
	s2.global_position = pos
	s2.play()
	
	# Destroy after some time
	var t := s2.create_tween()
	t.tween_interval(3.0)
	t.tween_callback(func(): if s2: s2.queue_free())
