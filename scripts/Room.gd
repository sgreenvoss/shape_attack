# defining class room
class_name Room
extends Node

var room_dimension_list = {
	"enemy": Vector2(15, 10),
	"smallenemy": Vector2(3, 3),
	"dirt": Vector2(0, 0),
	"treasure":  Vector2(3, 3),
	"misc": Vector2(6, 3),
	#"xfull_room": Vector2(WorldGenerator.HORIZONTAL_BOUND + 2, WorldGenerator.VERTICAL_BOUND + 2)
	
}
const WALLS_GRASS = {
	'n': Vector2(14, 0), 's': Vector2(14, 2),
	'e': Vector2(15, 1), 'w': Vector2(13, 1),
	'ne': Vector2(15, 0), 'se': Vector2(15, 2),
	'sw': Vector2(13, 2), 'nw': Vector2(13, 0)
}
const WALLS_BRICK = {
	'n': Vector2(9, 10), 's': Vector2(9, 12),
	'e': Vector2(10, 11), 'w': Vector2(8, 11),
	'ne': Vector2(10, 10), 'se': Vector2(10, 12),
	'sw': Vector2(8, 12), 'nw': Vector2(8, 10)
}

var room_type : String
var position : Vector2i
var health : int
var walls : Dictionary
var floors : Array
var object_spawn_rates : Array
var room_dimensions :Vector2i

# constructor
func _init(rt, pos):
	room_type = rt
	position = pos
	room_dimensions = room_dimension_list[room_type]
	print('room_diemnsions: ', str(room_dimensions))
	
	# can change later to modify floors
	floors = [Vector2(1, 0)]
	
	match room_type:
		"enemy":
			walls = WALLS_GRASS
			health = 2
		"treasure":
			walls = WALLS_BRICK
			health = 4
		"smallenemy":
			walls = WALLS_GRASS
			health = 2
		"misc":
			walls = WALLS_BRICK
			health = 4
		"dirt":
			walls = {}
			health = 1
		"xfull_room":
			walls = WALLS_BRICK
			health = INF
		_:
			pass
