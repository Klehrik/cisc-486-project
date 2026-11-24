class_name SFX
extends Node3D

static var instance: SFX

var sfx:    Dictionary[String, AudioStreamPlayer] = {}
var sfx_3d: Dictionary[String, AudioStreamPlayer3D] = {}

func _ready() -> void:
	assert(not instance, "SFX singleton already exists.")
	instance = self

	# Register SFX child nodes
	for s: AudioStreamPlayer in find_children("*", "AudioStreamPlayer"):
		sfx[s.name] = s
	for s: AudioStreamPlayer3D in find_children("*", "AudioStreamPlayer3D"):
		sfx_3d[s.name] = s

## Play a sound at a global position (if it is a positional sound).
static func play(name: String, pos: Vector3 = Vector3.ZERO) -> void:
	if not instance:
		return
	
	var s: AudioStreamPlayer = instance.sfx.get(name)
	if s:
		s.play()
		return
		
	var s2: AudioStreamPlayer3D = instance.sfx_3d.get(name)
	if s2:
		# Duplicate node and play at position
		var s3 := s2.duplicate()
		instance.add_child(s3)
		s3.global_position = pos
		s3.play()
		
		# Destroy after some time
		var t := s3.create_tween()
		t.tween_interval(3.0)
		t.tween_callback(func(): if s3: s3.queue_free())
		return
		
	assert(false, "SFX '%s' does not exist." % name)
