class_name StateMachine
extends Node

var states: Dictionary[String, State] = {}
var stack: Array[State] = []
var current: State:
	get():
		return stack.back()
	set(value):
		assert(false, "current is read only.")

func _ready() -> void:
	await owner.ready
	
	# Register State child nodes and
	# start at the first/topmost one
	var first: State = null
	for state: State in get_children():
		states[state.name] = state
		if not first:
			first = state
	push(first.name)
	
func _physics_process(delta: float) -> void:
	current.on_process(delta)

func push(name: String) -> void:
	var c := current
	if c and c.name == name:
		return
	var next: State = states.get(name)
	assert(next, "State '%s' does not exist." % name)
	
	if c:
		c.is_current_state = false
		c.on_exit()
	
	stack.append(next)
	c = current
	if c:
		c.is_current_state = true
		c.on_push()
		c.on_enter()

func pop() -> void:
	if len(stack) <= 1:
		push_error("Cannot pop last state.")
		return
	
	var c := current
	if c:
		current.is_current_state = false
		current.on_exit()
		current.on_pop()
	
	stack.pop_back()
	c = current
	if c:
		c.is_current_state = true
		c.on_enter()

func switch(name: String) -> void:
	var c := current
	if c and c.name == name:
		return
	var next: State = states.get(name)
	assert(next, "State '%s' does not exist." % name)
	
	if c:
		c.is_current_state = false
		c.on_exit()
		c.on_pop()
	
	stack.pop_back()
	stack.append(next)
	c = current
	if c:
		c.is_current_state = true
		c.on_push()
		c.on_enter()
