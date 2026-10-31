class_name Camera
extends Node3D

static var instance: Camera

var targets: Array[Array] = []	## List of followable targets [br]If multiple targets, will stay between primary and next nearest (unless primary target is offscreen) [br]Higher values are prioritized for primary and secondary targets
var slide_speed := 3.5			## Camera [code]exp_decay()[/code] slide speed
var secondary_target_max_dist := 10.0	## in metres

var base_orientation: CameraOrientation	## Original camera orientation; do not set
var base_dist: float					## Base distance ([code]z[/code]) of camera (35.0m)
var orientations: Array[Array] = [] 	## List of target camera orientations [br]Highest prioritization is used as the current orientation
var current_dist_scale := 1.0 			## [code]1.0[/code] at base

class CameraOrientation:
	var rotation: Vector3
	var offset: Vector3
	var dist_scale: float		## Scaling value for camera [code]z[/code] distance [br][code]1.0[/code] at base
	var speed: float			## [code]exp_decay()[/code] orientation speed [br][code]5.0[/code] at base
	var ignore_secondary: bool	## Whether to ignore secondary targets when camera panning
	var base: Array				## Original initialized values
	
	func _init(
		rotation: Vector3,
		offset: Vector3 		= Vector3.ZERO,
		dist_scale: float 		= 1.0,
		speed: float 			= 5.0,
		ignore_secondary: bool 	= false
	) -> void:
		self.rotation 			= rotation
		self.offset 			= offset
		self.dist_scale 		= dist_scale
		self.speed				= speed
		self.ignore_secondary 	= ignore_secondary
		base = [rotation, offset, dist_scale, speed, ignore_secondary]
	
	## Reset to original initialized values
	func reset() -> void:
		rotation		 = base[0]
		offset 			 = base[1]
		dist_scale 		 = base[2]
		speed			 = base[3]
		ignore_secondary = base[4]

func _ready() -> void:
	assert(not instance, "Camera singleton already exists.")
	instance = self
	base_orientation = CameraOrientation.new(rotation)
	base_dist = $Camera3D.position.z

func _process(delta: float) -> void:
	# Set orientation
	var o := base_orientation
	if len(orientations) > 0:
		o = orientations[0][0]
	rotation = Util.exp_decay(rotation, o.rotation, o.speed, delta)
	current_dist_scale = Util.exp_decay(current_dist_scale, o.dist_scale, o.speed, delta)
	$Camera3D.position.z = base_dist * current_dist_scale
	
	# Set target position
	var dest := position + o.offset
	var n := len(targets)
	if n > 0:
		# First target is the primary one (highest priority)
		var target: Node3D = targets[0][0]
		dest = target.global_position
		
		if n > 1 and !o.ignore_secondary:
			# Secondary target is the nearest one with highest priority
			var priority: float = targets[1][1]
			var candidates = targets.filter(func(a): return a[1] == priority)
			var target2: Node3D
			var dist := INF
			for tarray in candidates:
				var t: Node3D = tarray[0]
				var d: float = (t.global_position - dest).length_squared()
				if d < dist:
					target2 = t
					dist = d
			
			var pos2 := target2.global_position
			if (dest - pos2).length() <= secondary_target_max_dist:
				dest = (dest + pos2) / 2
		
		dest += o.offset
	
	# Slide to destination
	position = Util.exp_decay(position, dest, slide_speed, delta)

## Apply camera rotation to vector
func get_relative(vec: Vector3) -> Vector3:
	return vec.rotated(Vector3.UP, rotation.y)

## Get original vector from camera-rotated one
func get_original(vec: Vector3) -> Vector3:
	return vec.rotated(Vector3.UP, -rotation.y)

func project_position(pos: Vector2) -> Vector3:
	return $Camera3D.project_position(pos, $Camera3D.position.z)

func add_target(target: Node3D, priority: int = 0) -> void:
	var t = targets.find_custom(func(a): return a[0] == target)
	if t < 0:
		# Add and sort by highest to lowest priority
		targets.append([target, priority])
		targets.sort_custom(func(a, b): return a[1] > b[1])

func remove_target(target: Node3D) -> void:
	var t = targets.find_custom(func(a): return a[0] == target)
	if t >= 0:
		targets.remove_at(t)

func add_orientation(orientation: CameraOrientation, priority: int = 0) -> void:
	var t = orientations.find_custom(func(a): return a[0] == orientation)
	if t < 0:
		# Add and sort by highest to lowest priority
		orientations.append([orientation, priority])
		orientations.sort_custom(func(a, b): return a[1] > b[1])

func remove_orientation(orientation: CameraOrientation) -> void:
	var t = orientations.find_custom(func(a): return a[0] == orientation)
	if t >= 0:
		orientations.remove_at(t)
