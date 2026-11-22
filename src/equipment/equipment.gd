class_name Equipment
extends Node

## Inherit this and override [code]use[/code] and [code]stop[/code] when needed.

var cooldown_max: float	 ## The cooldown for this equipment (in seconds).
var cooldown_left: float ## The remaining cooldown for this equipment (in seconds).

func _init() -> void:
	Scene.add_to_tree(self, "Process")

func _process(delta: float) -> void:
	if cooldown_left > 0:
		cooldown_left -= delta

func is_on_cooldown() -> bool:
	return cooldown_left > 0

## [code]cd_mult[/code] is a scaling of [code]cooldown_max[/code].
func start_cooldown(cd_mult: float = 1.0) -> void:
	cooldown_left = cooldown_max * cd_mult

## Called once (or every frame) whenever the equipment is being used.
## Returns [code]true[/code] if the equipment was successfully used.
func use(use_origin: UseOrigin) -> bool:
	return true

## Called once when the user stops using the equipment.
func stop(use_origin: UseOrigin) -> void:
	pass

## Called every frame.
func process(delta: float) -> void:
	pass
