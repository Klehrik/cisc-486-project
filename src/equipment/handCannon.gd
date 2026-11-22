class_name Equipment_HandCannon
extends Equipment

var damage 	  := 3.0
var stun	  := 4.0
var knockback := 15.0
var speed 	  := 80.0
var cooldown  := 7.0	## In seconds.
var noise	  := 12.0	## Noise strength.

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
	p.scale_projectile(2)
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
