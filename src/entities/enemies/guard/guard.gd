class_name Guard
extends BaseEnemy

var equipment: Equipment

@onready var model: GuardModel	   = $Model
@onready var use_origin: UseOrigin = $UseOrigin

func _ready() -> void:
	super()
	equipment = Equipment_GuardGun.new(2)
	if equipment:
		var uo := model.set_equipment(equipment)
		if uo:
			use_origin.follow = uo

func handle_equipment_use(range_multiplier: float = 1.0) -> void:
	if equipment and target and vision.can_see_point(target.global_position, range_multiplier):
		equipment.use(use_origin)
