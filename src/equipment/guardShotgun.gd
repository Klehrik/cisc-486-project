class_name Equipment_GuardShotgun
extends Equipment_Shotgun

func _init(team: int = 0) -> void:
	cooldown = 4.0
	super(team)
