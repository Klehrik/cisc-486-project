class_name Player
extends CharacterBody3D

var move_speed := 2.5
var rotation_speed := 16.0			## [code]exp_decay_angle()[/code] rotation rate.
const footstep_dist := 0.5			## How far the player needs to travel to trigger another footstep (in metres).

var last_move_dir := Vector3.RIGHT	## Normalized direction of last movement.
var last_footstep: Vector3			## Last saved footstep position.
var wallhug_normal: Vector3			## Normal of the wall being hugged.

var stamina_max := 2.0	## Number of consecutive rolls that can be made.
var stamina := stamina_max:
	get():
		return stamina
	set(value):
		stamina = clamp(value, 0.0, stamina_max)
const stamina_recover_speed := 1/1.5	## Stamina gain per second.

var pitch: Camera.CameraOrientation
var wallhug: Camera.CameraOrientation

var equipment: Array[Equipment] = []
var equipment_current: int
var acquired_equipment := false
#var face_use_direction: float		## Face use direction for a bit when using (in seconds).
#var face_use_direction_max := 1.0	## Face use direction for a bit when using (in seconds).

@onready var model: PlayerModel	   		 = $Model
@onready var physics: Physics 	   		 = $Physics
@onready var use_origin: UseOrigin 		 = $UseOrigin
@onready var hurtbox: Hurtbox 	   		 = $Hurtbox
@onready var state_machine: StateMachine = $StateMachine

func _ready() -> void:
	var camera := Camera.instance
	camera.add_target(self, 100)
	pitch = Camera.CameraOrientation.new(
		Vector3(deg_to_rad(-80.0),
				camera.base_orientation.rotation.y,
				camera.base_orientation.rotation.z)
	)
	wallhug = Camera.CameraOrientation.new(
		Vector3(deg_to_rad(-18.0), 0, 0),
		Vector3.UP * 2,
		0.5,
		-1,
		true
	)
	
	equipment = [Equipment.new()]
	EquipmentWheel.instance.update_data(equipment, equipment_current)
	
	Event.pickup.connect(_on_pickup)
	
	HUDHealth.instance.hurtbox = hurtbox
	HUDStamina.instance.player = self
	
	# DEBUG
	#equipment = [
	#	Equipment_BurstPistol.new(1),
	#	Equipment_StunPistol.new(1),
	#	Equipment_Cannon.new(1),
	#	Equipment_Shotgun.new(1),
	#]
	#var uo := model.set_equipment(equipment[equipment_current])
	#if uo:
	#	use_origin.follow = uo
	#EquipmentWheel.instance.update_data(equipment, equipment_current)

func _physics_process(delta: float) -> void:
	handle_camera_pitch()
	handle_equipment(delta)
	
	# Face use direction
	if hurtbox.health > 0:
		rotate_to_look_at(use_origin.target, delta)
	
	# Stamina
	stamina += stamina_recover_speed * delta
	
	#if face_use_direction > 0:
	#	face_use_direction -= delta
	#	rotate_to_look_at(use_origin.target, delta)
	#else:
	#	rotate_to_look_at(global_position + last_move_dir, delta)

func handle_movement(speed_multiplier: float = 1.0) -> void:
	var input_vec := Input.get_vector("Left", "Right", "Up", "Down")
	var move_dir := Camera.instance.get_relative(Vector3(input_vec.x, 0, input_vec.y))
	if move_dir != Vector3.ZERO:
		last_move_dir = move_dir
	physics.move_vec = move_dir * move_speed * speed_multiplier
	
	if (global_position - last_footstep).length() > footstep_dist:
		last_footstep = global_position
		Event.footstep.emit(self, global_position)

func handle_camera_pitch() -> void:
	var camera := Camera.instance
	if Input.is_action_pressed("Pitch"):
		camera.add_orientation(pitch)
	else:
		camera.remove_orientation(pitch)

func handle_camera_wallhug() -> bool:
	var camera := Camera.instance
	var space_state := get_world_3d().direct_space_state

	# Check if still touching wall (since `is_on_wall()` is inconsistent at that)
	var query := PhysicsRayQueryParameters3D.create(
		global_position,
		global_position + (-wallhug_normal * 0.32),
		collision_mask
	)
	var result := space_state.intersect_ray(query)
	if result:
		# Modify wallhug orientation when pitched
		if Input.is_action_pressed("Pitch"):
			wallhug.rotation.x = deg_to_rad(-45.0)
			wallhug.offset     = Vector3.UP * 4
			wallhug.dist_scale = 0.7
		else:
			wallhug.reset()
			
		# Rotate orientation to face wall
		wallhug.rotation.y = atan2(result.normal.x, result.normal.z)
		
		camera.add_orientation(wallhug, 1)
		return true
		
	else:
		camera.remove_orientation(wallhug)
		return false

func handle_equipment(delta: float) -> void:
	# Set equipment target position
	var vp := get_viewport()
	if vp:
		use_origin.target = Camera.instance.project_position_to_ground(vp.get_mouse_position(), use_origin.global_position.y)
	
	# Handle swapping
	var swapped := false
	var spin_direction := EquipmentWheel.SpinDirection.NONE
	if Input.is_action_just_pressed("Swap Left"):
		equipment_current = posmod(equipment_current - 1, len(equipment))
		swapped = true
		spin_direction = EquipmentWheel.SpinDirection.LEFT
	if Input.is_action_just_pressed("Swap Right"):
		equipment_current = posmod(equipment_current + 1, len(equipment))
		swapped = true
		spin_direction = EquipmentWheel.SpinDirection.RIGHT
	
	var e := equipment[equipment_current]
	EquipmentWheel.instance.update_labels(e.equipment_name, e.uses, e.uses_max)
	EquipmentWheel.instance.update_cooldown_ratio(e.cooldown_ratio)
	
	if swapped:
		update_equipment_model()
		EquipmentWheel.instance.update_data(equipment, equipment_current, spin_direction)

func handle_equipment_use() -> void:
	var e := equipment[equipment_current]
	if Input.is_action_pressed("Use"):
		e.use(use_origin)
		#face_use_direction = face_use_direction_max
	if Input.is_action_just_released("Use"):
		e.stop(use_origin)

## Rotate to face a point. [br]Should be called every frame while rotating.
func rotate_to_look_at(pos: Vector3, delta: float) -> void:
	var d := pos - position
	var dest := atan2(-d.x, -d.z)
	rotation.y = Util.exp_decay_angle(rotation.y, dest, rotation_speed, delta)

## Returns [code]true[/code] if touching wall with movement input.
func is_pushing_against_wall() -> bool:
	if not is_on_wall():
		return false
	var input_vec := Input.get_vector("Left", "Right", "Up", "Down")
	return input_vec != Vector2.ZERO

func update_equipment_model() -> void:
	var e = equipment[equipment_current]
	var uo := model.set_equipment(e)
	if uo:
		use_origin.follow = uo

func _on_hurtbox_hurt(hurtbox: Hurtbox, hitbox: Hitbox) -> void:
	Stats.damage_taken += hitbox.damage
	
	# Apply knockback
	if hurtbox.health > 0:
		physics.kb_vec += hitbox.kb_vec
	
	# Check if dead
	if hurtbox.health <= 0:
		state_machine.push("Dead")
		
		#await get_tree().process_frame
		#var tree := get_tree()
		#if tree:
		#	tree.reload_current_scene()

func _on_separation_collision(push: Vector3) -> void:
	physics.kb_vec += push / 2.0

func _on_pickup(equipment: Equipment, pickup: Pickup) -> void:
	# horrible shit
	# check equipment existence by name
	var index := self.equipment.find_custom(func(e: Equipment): return e.equipment_name == equipment.equipment_name)
	
	if index == -1:
		# delete the fucking empty placeholder equip
		if not acquired_equipment:
			self.equipment = []
			acquired_equipment = true
		
		self.equipment.append(equipment)
		update_equipment_model()
		EquipmentWheel.instance.update_data(self.equipment, equipment_current)
		pickup.mark_acquired()
		HUDPopup.add("Acquired %s" % equipment.equipment_name)
		
	else:
		var e := self.equipment[index]
		var count := e.gain_uses()
		if count > 0:
			pickup.mark_acquired()
			HUDPopup.add("+%s %s ammo" % [count, equipment.equipment_name])
		else:
			HUDPopup.add("[color=red]Already at max ammo[/color]")
