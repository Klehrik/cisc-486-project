class_name Guard
extends BaseEnemy

var equipment: Equipment

@onready var model: Node3D 		   = $Model
@onready var use_origin: UseOrigin = $UseOrigin

func _ready() -> void:
	super()
	equipment = Equipment_GuardRifle.new(2)

func _physics_process(delta: float) -> void:
	model.facing = -global_basis.z

func handle_equipment_use(range_multiplier: float = 1.0) -> void:
	if target and vision.can_see_point(target.global_position, range_multiplier):
		equipment.use(use_origin)
