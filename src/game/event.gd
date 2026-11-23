extends Node

## Emitted by things that make noise.
signal noise(pos: Vector3, sound_range: float)

## Emitted when a Team 1 entity takes a step.
signal footstep(entity: Node3D, pos: Vector3)

## Emitted when a Team 1 entity touches a Pickup. [br]
## Call [code]pickup.mark_acquired()[/code] if successful.
signal pickup(equipment: Equipment, pickup: Pickup)

## Emitted when Dialogue has started.
signal dialogue_start()

## Emitted when Dialogue has finished.
signal dialogue_end()
