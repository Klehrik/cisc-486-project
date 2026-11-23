extends Node

## Contains functions that run through a bunch of other stuff.
# end-stage coderot		this is the class of "do whatever"
# what the fuck is a 'modularity' :speaking_head: :fire: :fire:

## Handles player death.
func player_death() -> void:
	var tween := create_tween()
	tween.tween_interval(3.0)
	tween.tween_callback(
		func():
			Fade.instance.tween_to_value(1.0, 3.0)
	)
	tween.tween_interval(5.0)
	tween.tween_callback(
		func():
			get_tree().reload_current_scene()
	)
