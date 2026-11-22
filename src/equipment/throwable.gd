class_name Throwable
extends Equipment

var team: int

func _init(team: int) -> void:
	super()
	self.team = team
	#cooldown_max = cooldown
	#uses_max = ammo
	#uses = uses_max
	
	#model = preload("res://assets/models/equipment/pistol.tscn")
	#arm_pose = HumanoidModel.ArmPoses.PISTOL

func use(use_origin: UseOrigin) -> bool:
	return true
	
func stop(use_origin: UseOrigin) -> void:
	pass
