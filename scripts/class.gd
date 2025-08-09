extends Node

var attack_data = {
	'mage': {
		'dmg': 3,
		'cooldown': 5,
	},
	'thief': {
		'dmg': 1,
		'cooldown': 0 
	},
	'fighter': {
		'dmg': 3,
		'cooldown': 3
	},
	'gunslinger': {
		'dmg': 10,
		'cooldown': 10
	},
	'conway': {}
}

var attack_patterns := {
	"thief": {
		"up":    [Vector2i(0, -1)],
		"down":  [Vector2i(0,  1)],
		"left":  [Vector2i(-1, 0)],
		"right": [Vector2i( 1, 0)]
	},
	"fighter": {
		"up": [
			Vector2i(-1, -1), Vector2i(0, -1), Vector2i(1, -1),
			Vector2i(-1,  0),                   Vector2i(1,  0),
			Vector2i(-1,  1), Vector2i(0,  1), Vector2i(1,  1)
		],
		"down": [
			Vector2i(-1, -1), Vector2i(0, -1), Vector2i(1, -1),
			Vector2i(-1,  0),                   Vector2i(1,  0),
			Vector2i(-1,  1), Vector2i(0,  1), Vector2i(1,  1)
		],
		"left": [
			Vector2i(-1, -1), Vector2i(0, -1), Vector2i(1, -1),
			Vector2i(-1,  0),                   Vector2i(1,  0),
			Vector2i(-1,  1), Vector2i(0,  1), Vector2i(1,  1)
		],
		"right": [
			Vector2i(-1, -1), Vector2i(0, -1), Vector2i(1, -1),
			Vector2i(-1,  0),                   Vector2i(1,  0),
			Vector2i(-1,  1), Vector2i(0,  1), Vector2i(1,  1)
		]
	},
	"gunslinger": {
		"up": [
			
		]
	}
}
