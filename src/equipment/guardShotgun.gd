class_name Equipment_GuardShotgun
extends Equipment_Shotgun

func _init(team: int) -> void:
	cooldown = 4.0
	super(team)
