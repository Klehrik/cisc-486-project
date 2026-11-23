class_name Dialogue
extends Node2D

static var instance: Dialogue
	
const text_speed := 25.0		## Characters per second

var lines: Array[String]
var chars: float

@onready var label: RichTextLabel = $Label
@onready var arrow: Sprite2D 	  = $Arrow

func _ready() -> void:
	assert(not instance, "Dialogue singleton already exists.")
	instance = self

func _process(delta: float) -> void:
	arrow.visible = false
	if not lines:
		return
	
	chars += text_speed * delta
	label.text = lines[0]
	label.visible_characters = int(chars)
		
	if Input.is_action_just_pressed("Progress"):
		if label.visible_ratio >= 1.0:
			lines.remove_at(0)
			chars = 0
			label.text = ""
		else:
			chars = 1000
			
	if label.visible_ratio >= 1.0:
		arrow.visible = true

func start_dialogue(dialogue: Array[String]) -> void:
	lines = dialogue.duplicate()
	chars = 0
