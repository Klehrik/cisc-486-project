class_name BaseStunned
extends State

@onready var _owner: BaseEnemy = owner

func on_enter() -> void:
	_owner.navigation.stop()
	_owner.status_label.set_status(StatusLabel.Status.STUNNED)
	_owner.speech.talk(Dialogue.Status.Stunned.pick_random())

func on_process(delta: float) -> void:
	_owner.stun_time -= delta
	if _owner.stun_time <= 0:
		parent.pop()
