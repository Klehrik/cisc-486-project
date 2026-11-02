class_name StateMachine
extends Node

var states: Dictionary[String, State] = {}
var current: State = null

func _ready() -> void:
	await owner.ready
	
	# Register State child nodes and
	# start at the first/topmost one
	var first: State = null
	for state: State in get_children():
		states[state.name] = state
		if not first:
			first = state
	switch(first.name)
	
func _physics_process(delta: float) -> void:
	if current:
		current.on_process(delta)

func switch(name: String) -> void:
	if current and current.name == name:
		return
	var next: State = states.get(name)
	assert(next, "State '%s' does not exist." % name)
	if current:
		current.is_current_state = false
		current.on_exit()
	current = next
	current.is_current_state = true
	current.on_enter()
