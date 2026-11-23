extends State

@onready var _owner: Player = owner

func _init() -> void:
	Event.dialogue_end.connect(_on_dialogue_end)

func on_enter() -> void:
	_owner.hurtbox.is_active = false
	_owner.physics.move_vec = Vector3.ZERO

func _on_dialogue_end() -> void:
	_owner.hurtbox.is_active = true
	parent.pop()
