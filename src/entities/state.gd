class_name State
extends Node

@onready var parent: StateMachine = get_parent()	## The [code]StateMachine[/code] that this state belongs to.
var is_current_state: bool = false					## [code]true[/code] if this state is the currently active one.

func on_enter() -> void:
	pass
	
func on_process(delta: float) -> void:
	pass
	
func on_exit() -> void:
	pass
