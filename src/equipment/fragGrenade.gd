class_name FragGrenade
extends Throwable

func _init(team: int) -> void:
	super(team)

func use(use_origin: UseOrigin) -> bool:
	return true
	
func stop(use_origin: UseOrigin) -> void:
	pass
