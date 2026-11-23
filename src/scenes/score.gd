extends Node2D

func _ready() -> void:
	var min := int(Stats.time_taken) / 60
	var sec := int(Stats.time_taken - (min * 60.0))
	
	# Scale by 10 so there's no fractional damage
	# (as if player had 100 health instead of 10)
	var damage_taken := int(Stats.damage_taken * 10)
	
	var values := ""
	values += "%02d:%02d\n" % [min, sec]
	values += "%s\n" % Stats.enemies_alerted
	values += "%s\n" % Stats.enemies_killed
	values += "%s\n" % damage_taken
	$Values.text = values
