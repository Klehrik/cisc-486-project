class_name EquipmentPickup
extends Pickup

@export var equipment_script: Script
var equipment: Equipment
var acquired := false

func _physics_process(delta: float) -> void:
	super(delta)
	
	# Try to get equipment and spawn model
	if not equipment:
		equipment = equipment_script.new(1)
		if equipment and equipment.model:
			var m = equipment.model.instantiate()
			add_child(m)
			for do: DisplayOrigin in find_children("*", "DisplayOrigin"):
				m.position -= do.position
				break
			m.position.y += 0.5	# uh huh (i moved everything 0.5 up)

func _on_body_entered(body: Node3D) -> void:
	if acquired:
		return
	Event.pickup.emit(equipment, self)
	
## To be called by acquirer if successful.
func mark_acquired() -> void:
	if acquired:
		return
	acquired = true
	
	play_animation()
