extends Node2D

var HORIZONTAL_BOUND = 40
var VERTICAL_BOUND = 40

var world_grid = []
var rooms = ["enemy", "treasure", "smallenemy", "misc", "xfull_room"]
var active_rooms = {"enemy": 4, "treasure": 2, "smallenemy": 10, "misc": 6}
var dirt_tiles = [Vector2(1, 0), Vector2(5, 2), Vector2(1,0), Vector2(2, 2), Vector2(4, 2), Vector2(1,0)]
var mined_tile = Vector2(10, 1)
var abbr_walls = ['e', 't', 's', 'm', 'x', 'd']

@onready var tile_map = $"../TileMapLayer"
@onready var player = $"../player"



var room_data = {
	"enemy": {'x': 15, 'y': 10, 
		'health': 2,
		'walls': {'n': Vector2(14, 0), 's': Vector2(14, 2),
				'e': Vector2(15, 1), 'w': Vector2(13, 1),
				'ne': Vector2(15, 0), 'se': Vector2(15, 2),
				'sw': Vector2(13, 2), 'nw': Vector2(13, 0)},
		#'floors': [Vector2(1, 2), Vector2(3,2), Vector2(5,2)]
		'floors': [Vector2(1, 0)]
	},
	
	"dirt": {'x': 0, 'y': 0, 
		'health': 1,
		'walls': {},
		#'floors': [Vector2(1, 2), Vector2(3,2), Vector2(5,2)]
		'floors': [Vector2(1, 0), Vector2(5, 2), Vector2(1,0), Vector2(2, 2), Vector2(4, 2), Vector2(1,0)]
	},
	
	"treasure":  {'x': 3, 'y': 3, 
		'health': 4,
		'walls': {'n': Vector2(9, 10), 's': Vector2(9, 12),
					'e': Vector2(10, 11), 'w': Vector2(8, 11),
					'ne': Vector2(10, 10), 'se': Vector2(10, 12),
					'sw': Vector2(8, 12), 'nw': Vector2(8, 10)},
		'floors': [Vector2(1, 0)]
	},
	
	"smallenemy": {'x': 3, 'y': 3, 
		'health': 2,
		'walls': {'n': Vector2(14, 0), 's': Vector2(14, 2),
				'e': Vector2(15, 1), 'w': Vector2(13, 1),
				'ne': Vector2(15, 0), 'se': Vector2(15, 2),
				'sw': Vector2(13, 2), 'nw': Vector2(13, 0)},
		#'floors': [Vector2(1, 2), Vector2(3,2), Vector2(5,2)]
		'floors': [Vector2(1,0)]
	},
	
	"misc": {'x': 6, 'y': 3, 
		'health': 4,
		'walls': {'n': Vector2(9, 10), 's': Vector2(9, 12),
				'e': Vector2(10, 11), 'w': Vector2(8, 11),
				'ne': Vector2(10, 10), 'se': Vector2(10, 12),
				'sw': Vector2(8, 12), 'nw': Vector2(8, 10)},
		'floors': [Vector2(1, 0)]
	},
	
	"xfull_room": {'x': HORIZONTAL_BOUND + 2, 'y': VERTICAL_BOUND + 2, 
		'health': INF,
		'walls': {'n': Vector2(9, 10), 's': Vector2(9, 12),
				'e': Vector2(10, 11), 'w': Vector2(8, 11),
				'ne': Vector2(10, 10), 'se': Vector2(10, 12),
				'sw': Vector2(8, 12), 'nw': Vector2(8, 10)},
		'floors': []
	}
}

func set_up_cell(type):
	return {'type': type[0], 'health': room_data[type]['health']}

func just_walls():
	# generates the world border for the game.
	# could easily be adapted to generate a floorless room
	for y in range(-1, VERTICAL_BOUND + 1):
		for x in range(-1, HORIZONTAL_BOUND + 1):
			var wall = is_wall("xfull_room", Vector2(-1, -1), Vector2(x, y))
			if wall:
				tile_map.set_cell(Vector2(x, y), 0, room_data["xfull_room"]['walls'][wall])
			else:
				pass


func choose_tile(room_type, room_positions, xy, current_cell):
	# room positions is dict that stores upper left corner of all rooms
	 # xy: the current coords in the grid
	var wall = is_wall(room_type, room_positions, xy)
	if wall and (!current_cell or room_type in ["misc", "treasure"]):
		tile_map.set_cell(xy, 0, room_data[room_type]['walls'][wall])
		world_grid[xy[1]][xy[0]] = set_up_cell(room_type)
	else:
		# randomly choose floor tile from available tiles
		tile_map.set_cell(xy, 0, room_data[room_type]['floors'][randi() %  room_data[room_type]['floors'].size()])
		world_grid[xy[1]][xy[0]]['health'] = 0
		world_grid[xy[1]][xy[0]]['type'] = 'r'
		
func fill_tile(coord):
	# fills a blank space tile with either the world border or blank tile 
	if coord[0] < 0 or coord[0] == HORIZONTAL_BOUND or coord[1] < 0 or coord[1] == VERTICAL_BOUND:
		world_grid[coord[1]][coord[0]] = set_up_cell('xfull_room')
		tile_map.set_cell(coord, 0, Vector2(5, 11))
	else:
		world_grid[coord[1]][coord[0]] = set_up_cell('dirt')
		tile_map.set_cell(coord, 0, dirt_tiles[randi() % dirt_tiles.size()])
	
func is_wall(room_type, room_position, xy):
	var walltype = ""
	# north wall?
	var room_dims = room_data[room_type]
	if xy[1] == room_position[1]:
		walltype += 'n'
	# south wall?
	elif xy[1] == room_position[1] + room_dims['y'] - 1:
		walltype += 's'
		
	# west wall?
	if xy[0] == room_position[0]:
		walltype += 'w'
	# east wall?
	elif xy[0] == room_position[0] + room_dims['x'] - 1:
		walltype += 'e'
		
	return walltype
	
func prepare_world_grid():
	var room_positions = {}
	
	for i in range(VERTICAL_BOUND):
		world_grid.append([])
		for j in range(HORIZONTAL_BOUND):
			world_grid[i].append({'type': '', 'health': 0})

	just_walls()
	
	for room in active_rooms:
		var room_count = active_rooms[room]
		for ct in range(room_count):
			var upperl_y = randi_range(0, VERTICAL_BOUND - room_data[room].y)
			var upperl_x = randi_range(0, HORIZONTAL_BOUND - room_data[room].x)
			for y in range(upperl_y, upperl_y + room_data[room].y):
				for x in range(upperl_x, upperl_x + room_data[room].x):
					choose_tile(room, Vector2(upperl_x, upperl_y), Vector2(x, y), world_grid[y][x]['type'])
	
	# fills the extra tiles
	for i in range(VERTICAL_BOUND):
		for j in range(HORIZONTAL_BOUND):
			if world_grid[i][j]['type'] != 'r' and world_grid[i][j]['type'] not in abbr_walls:
				fill_tile(Vector2(j, i))

func move(xy : Vector2):
	# is player trying to go oob?
	if xy.x < 0 or xy.x == HORIZONTAL_BOUND or xy.y < 0 or xy.y == VERTICAL_BOUND:
		return false
	
	# checks position that player wants to go to
	var position = world_grid[int(xy.y)][int(xy.x)]
	# if it's a wall,
	if position['type'] in abbr_walls:
		# if it's dead
		if position['health'] == 0:
			# make it a floor
			position['type'] = 'f'
			tile_map.set_cell(Vector2(xy.x, xy.y), 0, Vector2(10, 1))

		else:
			# attack it
			if player.shovel():
				position['health'] -= 1
			
	# returns if it's steppable
	return position['type'] not in abbr_walls

func _ready():
	prepare_world_grid()
