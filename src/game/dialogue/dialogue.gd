class_name Dialogue
extends Node2D

static var instance: Dialogue
	
const text_speed 	   := 25.0	## Characters per second.
const text_speed_punct := 3.0	## Characters per second for puncutation.
const punctuation	   := ".,!?:;"

var lines: Array[String]
var chars: float
var has_dialogue := false

@onready var label: RichTextLabel = $Label
@onready var arrow: Sprite2D 	  = $Arrow

func _ready() -> void:
	assert(not instance, "Dialogue singleton already exists.")
	instance = self

func _process(delta: float) -> void:
	arrow.visible = false
	has_dialogue = false
	if not lines:
		return
	has_dialogue = true
	
	label.text = lines[0]
	var line := label.get_parsed_text()
	if line[clamp(chars - 1, 0, len(line) - 1)] in punctuation:
		chars += text_speed_punct * delta
	else:
		chars += text_speed * delta
	label.visible_characters = int(chars)
		
	if Input.is_action_just_pressed("Progress"):
		if label.visible_ratio >= 1.0:
			lines.remove_at(0)
			chars = 0
			label.text = ""
			if not lines:
				Event.dialogue_end.emit()
		else:
			chars = 1000
			
	if label.visible_ratio >= 1.0:
		arrow.visible = true

func start_dialogue(dialogue: Array[String]) -> void:
	lines = dialogue.duplicate()
	chars = 0
