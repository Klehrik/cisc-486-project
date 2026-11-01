extends Node

## Useful range approx. [code]1[/code] (slow) to [code]25[/code] (fast) [br]
## Reference: [url]https://www.youtube.com/watch?v=LSNQuFEDOyQ[/url]
func exp_decay(a, b, decay: float, delta: float) -> Variant:
	return b + ((a - b) * exp(-decay * delta))

## Useful range approx. [code]1[/code] (slow) to [code]25[/code] (fast) [br]
## Reference: [url]https://www.youtube.com/watch?v=LSNQuFEDOyQ[/url]
func exp_decay_angle(a: float, b: float, decay: float, delta: float) -> float:
	var diff = fmod(b - a, TAU)
	var dist = fmod(2 * diff, TAU) - diff;
	return b - (dist * exp(-decay * delta))
