class_name Physics
extends Node

@export var knockback_decay := 5.0	## Knockback vector [code]exp_decay()[/code] rate
@export var gravity := 12.0

var move_vec 	:= Vector3.ZERO	## Base movement vector; unchanging on its own
var kb_vec   	:= Vector3.ZERO	## Knockback vector; decays over time
var velocity_y 	:= 0.0

@onready var _owner: CharacterBody3D = owner

func _process(delta: float) -> void:
	# Update position
	_owner.velocity = move_vec + kb_vec + (Vector3.DOWN * velocity_y)
	_owner.move_and_slide()
	
	# Apply gravity
	velocity_y += gravity * delta
	if _owner.is_on_floor():
		velocity_y = 0

	# Knockback vector decay
	kb_vec = kb_vec.normalized() * Util.exp_decay(kb_vec.length(), 0, knockback_decay, delta)
