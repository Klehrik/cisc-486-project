class_name Limb
extends TwoBone

## There should be 2 MeshInstance3D children in bone order. [br]
## They should be the same length as [code]length_1[/code] and [code]length_2[/code] respectively.

@export var target_marker: Marker3D		## The target position follows this marker.
@export var target_max_distance := 1.0	## The max distance from the marker before the leg moves (in metres).
@export var speed := 8.0				## Speed at which the target position moves to the marker (in m/s).
@export var exclusions: Array[Limb]		## Limb will not move while these limbs are moving.

var bones: Array[Node3D] = []
var is_moving := false
var current_pos: Vector3	## The current limb endpoint.
var target_pos: Vector3		## The target limb endpoint.

func _ready() -> void:
	await owner.ready
	for bone: Node3D in get_children():
		bones.append(bone)

func _process(delta: float) -> void:
	# Move limb if too far from marker
	if target_marker and not is_moving:
		var can_move := true
		for limb in exclusions:
			if limb.is_moving:
				can_move = false
				break
		if can_move:
			var marker_pos := target_marker.global_position
			if (current_pos - marker_pos).length() > target_max_distance:
				target_pos = marker_pos
				is_moving = true
	
	# Move target towards marker
	if is_moving:
		current_pos = current_pos.move_toward(target_pos, speed * delta)
		if current_pos == target_pos:
			is_moving = false
	
	# Position meshes
	target = current_pos
	var b1 := bones[0]
	var b2 := bones[1]
	b1.global_position = (global_position + midpoint) / 2
	b1.look_at(midpoint)
	b2.global_position = (midpoint + target) / 2
	b2.look_at(target)
