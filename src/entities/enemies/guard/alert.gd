extends BaseAlert

const initial_cooldown_mult := 0.5	## Multiplier for initial shoot delay.

@onready var __owner: Guard = owner

func on_enter() -> void:
	super()
	
	# Delay shooting when entering Alert
	if __owner.equipment:
		__owner.equipment.start_cooldown(initial_cooldown_mult)

func on_process(delta: float) -> void:
	super(delta)
	
	# Set use origin target
	var target := __owner.target
	if target:
		var use_origin := __owner.use_origin
		if use_origin:
			use_origin.target = Util.vector_zero_y(target.global_position, use_origin.global_position.y)
	
	__owner.handle_equipment_use(vision_mult)
