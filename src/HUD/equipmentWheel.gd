class_name EquipmentWheel
extends Node2D

static var instance: EquipmentWheel

enum SpinDirection {
	NONE  = 0,
	LEFT  = -1,
	RIGHT = 1,
}

const distance_from_corner := 0.65	## Model distance from corner.
const model_scale := 0.5
const angle_spacing := PI/6			## Offsets of other models from current one (at 45 deg angle).
const spin_speed := 8.0				## Model [code]exp_decay()[/code] spin speed

var models: Array[ModelData] = []	## Holds 5 (0, 1 are left, 2 is current, 3, 4 are right).
var equipment: Array[Equipment]		## Reference to equipment array to display.

@onready var sub_viewport: SubViewport = $SubViewportContainer/SubViewport

class ModelData:
	var model: EquipmentModel
	var angle: float
	var display_origin: Vector3

func _ready() -> void:
	assert(not instance, "EquipmentWheel singleton already exists.")
	instance = self
	
	for i in range(5):
		var data := ModelData.new()
		models.append(data)
	
	#var m: EquipmentModel = load("res://assets/models/equipment/rifle.tscn").instantiate()
	#sub_viewport.add_child(m)
	#m.scale = Vector3.ONE * model_scale
	#var display_origin := Vector3.ZERO
	#for do: DisplayOrigin in m.find_children("*", "DisplayOrigin"):
	#	display_origin = do.global_position
	#	break
	#m.position = (Vector3(0, 0, -distance_from_corner)).rotated(Vector3.LEFT, -PI/4) - display_origin

func _physics_process(delta: float) -> void:
	# Lerp each model angle to target one
	var angle_offset := -2
	for data in models:
		var dest := -PI/4 - (angle_spacing * angle_offset)
		angle_offset += 1
		data.angle = Util.exp_decay_angle(data.angle, dest, spin_speed, delta)
		if data.model:
			data.model.position = (Vector3(0, 0, -distance_from_corner)).rotated(Vector3.LEFT, data.angle) - data.display_origin
			data.model.visible = true

## Update model data and optionally spin.
func update_data(equipment: Array[Equipment], current: int, spin_direction: SpinDirection = SpinDirection.NONE) -> void:
	## Update leftmost (left 2) model first
	var count := len(equipment)
	current = posmod(current + 2, count)
	
	for data in models:
		var e := equipment[current]
		current = posmod(current - 1, count)
		
		# Destroy old model
		if data.model:
			data.model.queue_free()
			data.model = null
		
		# Create new model
		if e.model:
			var m: EquipmentModel = e.model.instantiate()
			sub_viewport.add_child(m)
			m.visible = false
			m.scale = Vector3.ONE * model_scale
			data.model = m
			data.display_origin = Vector3.ZERO
			for do: DisplayOrigin in m.find_children("*", "DisplayOrigin"):
				data.display_origin = do.global_position
				break
		
		# Optionally offset angle so they spin to the correct one
		if spin_direction != SpinDirection.NONE:
			data.angle += angle_spacing * spin_direction
