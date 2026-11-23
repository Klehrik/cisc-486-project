extends Node

## Emitted by things that make noise.
signal noise(pos: Vector3, sound_range: float)

## Emitted when a Team 1 entity takes a step.
signal footstep(entity: Node3D, pos: Vector3)

## Emitted when a Team 1 entity touches a Pickup.
signal pickup(equipment: Equipment)
