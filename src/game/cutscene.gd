extends Node

## Contains functions that run through a bunch of other stuff.
# end-stage coderot		this is the class of "do whatever"
# what the fuck is a 'modularity' :speaking_head: :fire: :fire:

func intro() -> void:
	var tween := create_tween()
	tween.tween_interval(2.0)
	tween.tween_callback(
		func():
			Dialogue.instance.start_dialogue(Text.Intro)
	)
	await Event.dialogue_end
	tween = create_tween()
	tween.tween_interval(2.0)
	await tween.finished
	await RenderingServer.frame_post_draw
	get_tree().change_scene_to_file("res://src/scenes/world.tscn")

func player_death() -> void:
	var tween := create_tween()
	tween.tween_interval(3.0)
	tween.tween_callback(
		func():
			Dialogue.instance.start_dialogue(Text.Death)
			Fade.instance.tween_to_value(1.0, 3.0)
	)
	tween.tween_interval(5.0)
	await tween.finished
	if Dialogue.instance.has_dialogue:
		await Event.dialogue_end
	tween = create_tween()
	tween.tween_interval(1.0)
	await tween.finished
	await RenderingServer.frame_post_draw
	get_tree().reload_current_scene()
