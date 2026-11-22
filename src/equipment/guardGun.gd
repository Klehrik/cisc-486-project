class_name Equipment_GuardGun
extends Equipment

var damage 	  := 1.0
var stun	  := 0.5
var knockback := 2.5
var speed 	  := 40.0
var spread	  := 8.0	## Total arc spread (in degrees).
var shots_max := 2		## Shots fired per burst.
var delay_max := 0.1	## Time between shots (in seconds).
var cooldown  := 3.0	## In seconds.
var noise	  := 9.0	## Noise strength.

var shots: int
var delay: float

var use_origin: UseOrigin
var team: int

func _init(team: int) -> void:
	super()
	self.team = team
	cooldown_max = cooldown

func use(use_origin: UseOrigin) -> bool:
	if not use_origin:
		return false
	if is_on_cooldown():
		return false
	self.use_origin = use_origin
	shots = shots_max
	start_cooldown()
	return true

func _physics_process(delta: float) -> void:
	if not use_origin:
		return
	
	if shots > 0:
		if delay > 0:
			delay -= delta
		else:
			delay = delay_max
			shots -= 1
			
			# Fire bullet
			var half_spread := deg_to_rad(spread/2.0)
			var dir := (use_origin.target - use_origin.global_position).normalized()
			dir = dir.rotated(Vector3.UP, randf_range(-half_spread, half_spread))
			
			var p: Projectile = Scene.instantiate_global(Scene.projectile)
			p.position = use_origin.global_position
			p.velocity = dir * speed
			p.damage = damage
			p.stun = stun
			p.kb_vec = dir * knockback
			p.set_team(team)

			if team == 1:
				Event.noise.emit(p.global_position, noise)
