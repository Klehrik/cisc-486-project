class_name Equipment_BurstPistol
extends Equipment

var damage 	  := 1.0
var stun	  := 0.5
var knockback := 2.5
var speed 	  := 50.0
var spread	  := 10.0	## Total arc spread (in degrees).
var shots_max := 3		## Shots fired per burst.
var delay_max := 0.1	## Time between shots (in seconds).
var cooldown  := 1.0	## In seconds.

var shots: int
var delay: float

var use_origin: UseOrigin
var team: int

func _init(team: int) -> void:
	self.team = team
	cooldown_max = cooldown

func use(use_origin: UseOrigin) -> bool:
	if is_on_cooldown():
		return false
	self.use_origin = use_origin
	shots = shots_max
	start_cooldown()
	return true

func _physics_process(delta: float) -> void:
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
