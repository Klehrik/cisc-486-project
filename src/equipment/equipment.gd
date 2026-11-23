class_name Equipment
extends Node

## Inherit this and override [code]use[/code] and [code]stop[/code] when needed.

var equipment_name := "--"
var model: PackedScene
var arm_pose: HumanoidModel.ArmPoses

var cooldown_max: float	 	## The cooldown for this equipment (in seconds).
var cooldown_left: float 	## The remaining cooldown for this equipment (in seconds).
var cooldown_ratio: float:	## 1.0 - (ratio of remaining to max).
	get():
		return 1.0 - (cooldown_left / cooldown_max)
	set(value):
		assert(false, "Cannot modify cooldown_ratio.")
var uses 	 := -1:		 	## Remaining uses. [br]Infinite if [code]-1[/code].
	get():
		return uses
	set(value):
		uses = clamp(value, -1, uses_max)
var uses_max := -1		 	## Maximum uses. [br]Infinite if [code]-1[/code].

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

## Tries to consumes a use and returns [code]true[/code] if successful.
func consume_use() -> bool:
	if uses <= -1:
		return true
	if uses > 0:
		uses -= 1
		return true
	return false

## Gain uses on pickup for existing equipment. [br]
## Defaults to 20% of max uses (rounded, minimum 1). [br]
## Returns the amount of uses gained.
func gain_uses(amount: float = 0.2) -> int:
	var gain: int = max(round(uses_max * amount), 1)
	var prev_uses := uses
	uses += gain
	return uses - prev_uses

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
