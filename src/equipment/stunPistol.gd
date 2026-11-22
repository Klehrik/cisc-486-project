class_name Equipment_StunPistol
extends Equipment

var damage 	  := 0.1
var stun	  := 2.5
var knockback := 1.0
var speed 	  := 50.0
var cooldown  := 1.5	## In seconds.
var noise	  := 2.0	## Noise strength.

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
	
	# Fire bullet
	var dir := (use_origin.target - use_origin.global_position).normalized()
	var p: Projectile = Scene.instantiate_global(Scene.projectile)
	p.scale_projectile(0.7)
	p.position = use_origin.global_position
	p.velocity = dir * speed
	p.damage = damage
	p.stun = stun
	p.kb_vec = dir * knockback
	p.set_team(team)

	if team == 1:
		Event.noise.emit(p.global_position, noise)
	
	start_cooldown()
	return true
