class_name Dialogue
extends Node

const Status = {
	Suspicion = [
		"Is somebody there?",
		"What was that?",
		"What the..?",
		"Huh?",
		"Is that..?",
		"..?",
	],
	Alert = [
		"Over here!",
		"Found someone!",
		"I need backup!",
		"An enemy!",
		#"Need support!",
		"Get over here!",
		"Hey!",
		"Intruder!",
		#"Big mistake!",
	],
	Search = [
		"What..?",
		"Huh?",
		"..?",
	],
	SearchAlerted = [		# Used instead if Alert -> Search transition happened
		"What..?",
		"Huh?",
		"..?",
		"Where did..?",
		"Stop hiding!",
		"Show yourself!",
		"I'll kill you!",
	],
	SearchEnd = [
		"Whatever.",
		"Must be imagining things..",
		"Nothing here.",
		"Nothing..",
		"...",
	],
	SearchEndAlerted = [	# Used instead if Alert -> Search transition happened
		"Whatever.",
		"They got away..",
		"Not here.",
		"Lost 'em..",
		"...",
	],
	Stunned = [
		"Augh!",
		"..!",
		"Oof!",
		"Ow!",
		#"AAAAHHHRGH!",
	],
}
