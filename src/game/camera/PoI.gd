class_name PoI
extends Marker3D

@export var priority := 0
@export var lifetime := -1.0
@export var secondary_target_max_dist := 10.0

func _init(priority: int = -1, lifetime: float = -1.0, secondary_target_max_dist: float = secondary_target_max_dist) -> void:
	self.priority = priority
	self.lifetime = lifetime
	self.secondary_target_max_dist = secondary_target_max_dist
	
func _ready() -> void:
	Camera.instance.add_target(self, priority, secondary_target_max_dist)

func _physics_process(delta: float) -> void:
	if lifetime > 0:
		lifetime -= delta
		if lifetime <= 0:
			Camera.instance.remove_target(self)
			queue_free()
