class_name TwoBone
extends Marker3D

@export var length_1 := 1.0	## Length of bone 1 (in metres).
@export var length_2 := 1.0	## Length of bone 2 (in metres).
var midpoint: Vector3		## The position of the joint connecting both lengths. [br]Automatically set when setting [code]target[/code].
var target: Vector3:		## The end of the limb (global position). [br]Setting will be automatically constrain to max length and calculate [code]midpoint[/code].
	get():
		return target
	set(value):
		target = _calculate_points(value)
var cross := Vector3.UP		## Cross vector used to get perpendicular for rotation plane.

## Calculates the joint position and returns the finalized target point.
func _calculate_points(end: Vector3) -> Vector3:
	var start 	:= global_position
	var vec 	:= end - start
	var length 	:= vec.length()
	var max_length := length_1 + length_2
	if length > max_length:
		length 	= max_length
		vec 	= vec.normalized() * length
		end		= start + vec
	
	# whatever, go my law of cosines
	var angle := acos(((length_1 ** 2) + (length ** 2) - (length_2 ** 2)) / (2 * length_1 * length))
	
	# Get perpendicular of 'vec x Vector3.UP' plane to rotate around
	var perp 		:= vec.cross(cross).normalized()
	if perp == Vector3.ZERO:
		perp = Vector3.UP
	var vec_to_mid 	:= vec.rotated(perp, angle).normalized()
	midpoint		= start + (vec_to_mid * length_1)
	
	return end
