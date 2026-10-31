class_name PoI
extends Marker3D

var priority := 0
var lifetime := -1.0

func _init(priority: int = -1, lifetime: float = -1.0) -> void:
	self.priority = priority
	self.lifetime = lifetime
	
func _ready() -> void:
	Camera.instance.add_target(self, priority)

func _physics_process(delta: float) -> void:
	if lifetime > 0:
		lifetime -= delta
		if lifetime <= 0:
			Camera.instance.remove_target(self)
			queue_free()
