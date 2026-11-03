extends Node

## Emitted by things that make noise.
signal noise(pos: Vector3, sound_range: float)

## Emitted by Noisy; Team 1 entities that interact with this should connect it
signal stepped_on_noisy(entity: Node3D, sound_range: float)
