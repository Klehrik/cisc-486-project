class_name State
extends Node

@onready var parent: StateMachine = get_parent()	## The [code]StateMachine[/code] that this state belongs to.
var is_current_state: bool = false					## [code]true[/code] if this state is the currently active one.

## Called when the state is pushed.
func on_push() -> void: pass

## Called when the state is entered [br](from being pushed or returned to).
func on_enter() -> void: pass

## Called every frame while in the state.
func on_process(delta: float) -> void: pass

## Called when the state is exited [br](from another state being pushed).
func on_exit() -> void: pass

## Called when the state is popped.
func on_pop() -> void: pass
