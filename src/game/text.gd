class_name Text
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

const Intro: Array[String] = [
	"Alright, I'm here. Building's in sight.",
	"[color=#8b9bb4]Good. Once again, your mission is to infiltrate the site and retrieve the target.",
	"[color=#8b9bb4]Stay alert, and well-hidden. Security is at a maximum, and even for you there is no chance of fighting your way through.",
	"Heh... well, if it comes to it, I think I can deal.",
	"[color=#8b9bb4]Hm. Don't be so reckless. \nThis isn't a game.",
	"[color=#8b9bb4]You [color=red]only have one life [color=#8b9bb4]in this world. \nThere are no redos or second chances.",
	"Course.",
	"[color=#8b9bb4]As usual, we are officially unaffiliated with this operation. \nYou will have to procure your own weapons on-site.",
	"[color=#8b9bb4]If you get caught, there'll be no help coming.",
	"Yeah, I get it. \nI'm heading in now.",
]

const Death: Array[String] = [
	"Hello? What's going on? \nRespond!",
]
