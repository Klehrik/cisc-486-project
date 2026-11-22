class_name Equipment_Shotgun
extends Equipment

var damage 	  := 0.8
var stun	  := 0.5
var knockback := 1.0
var speed_min := 20.0
var speed_max := 40.0
var spread	  := 25.0	## Total arc spread (in degrees).
var count	  := 8.0	## Pellet count.
var scale_min := 0.5
var scale_max := 0.8
var cooldown  := 2.5	## In seconds.
var ammo	  := 6
var noise	  := 12.0	## Noise strength.

var team: int

func _init(team: int) -> void:
	super()
	equipment_name = "Shotgun"
	self.team = team
	cooldown_max = cooldown
	uses_max = ammo
	uses = uses_max
	
	model = preload("res://assets/models/equipment/shotgun.tscn")
	arm_pose = HumanoidModel.ArmPoses.RIFLE

func use(use_origin: UseOrigin) -> bool:
	if not use_origin:
		return false
	if is_on_cooldown():
		return false
	if not consume_use():
		return false
	
	# Fire bullets
	for i in range(count):
		var half_spread := deg_to_rad(spread/2.0)
		var dir := (use_origin.target - use_origin.global_position).normalized()
		dir = dir.rotated(Vector3.UP, randf_range(-half_spread, half_spread))
		
		var p: Projectile = Scene.instantiate_global(Scene.projectile)
		p.scale_projectile(randf_range(scale_min, scale_max))
		p.position = use_origin.global_position
		p.velocity = dir * randf_range(speed_min, speed_max)
		p.damage = damage
		p.stun = stun
		p.kb_vec = dir * knockback
		p.set_team(team)

	if team == 1:
		Event.noise.emit(use_origin.global_position, noise)
	
	start_cooldown()
	return true
