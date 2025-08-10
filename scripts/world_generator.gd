extends Node2D
class_name WorldGenerator

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
		'floors': [Vector2(1, 0)],
		'obj_spawns': {'blob': {'min': 0, 'max': 10}}
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

func set_up_cell(tile: Tile, type: String):
	match type:
		"xfull_room":
			tile.health = INF
			tile.tile_type = "x"
		"dirt":
			tile.health = 1
			tile.tile_type = "d"

func just_walls():
	pass
	# generates the world border for the game.
	## could easily be adapted to generate a floorless room
	#for y in range(-1, VERTICAL_BOUND + 1):
		#for x in range(-1, HORIZONTAL_BOUND + 1):
			#var new_room = Room.new("xfull_room", Vector2(x, y))
			#var wall = is_wall("xfull_room", Vector2(x, y))
			#if wall:
				#tile_map.set_cell(Vector2(x, y), 0, room_data["xfull_room"]['walls'][wall])
			#else:
				#new_room.queue_free()
				#pass


func choose_tile(current_room : Room, current_position, tile_type):
	var wall = is_wall(current_room, current_position)
	# !current_cell_type or current_room.room_type in ["misc", "treasure"]
	if wall and (tile_type == "r"):
		tile_map.set_cell(current_position, 0, current_room.walls[wall])
		world_grid[current_position.y][current_position.x].revise(current_room)
	else:
		# randomly choose floor tile from available tiles
		tile_map.set_cell(current_position, 0, current_room.floors[randi() %  current_room.floors.size()])
		
func fill_tile(coord):
	# fills a blank space tile with either the world border or blank tile 
	if coord[0] < 0 or coord[0] == HORIZONTAL_BOUND or coord[1] < 0 or coord[1] == VERTICAL_BOUND:
		set_up_cell(world_grid[coord[1]][coord[0]], 'x')
		tile_map.set_cell(coord, 0, Vector2(5, 11))
	else:
		set_up_cell(world_grid[coord[1]][coord[0]], 'd')
		tile_map.set_cell(coord, 0, dirt_tiles[randi() % dirt_tiles.size()])
	
func is_wall(room : Room, xy : Vector2):
	# determines if the position xy in the room is a wall, and if so, which
	var walltype = ""
	# north wall?
	if xy.y == room.position.y:
		walltype += 'n'
	# south wall?
	elif xy.y == room.position.y + room.room_dimensions.y - 1:
		walltype += 's'
		
	# west wall?
	if xy.x == room.position.x:
		walltype += 'w'
	# east wall?
	elif xy.x == room.position.x + room.room_dimensions.x - 1:
		walltype += 'e'
		
	return walltype
	
func prepare_world_grid():
	for i in range(VERTICAL_BOUND):
		world_grid.append([])
		for j in range(HORIZONTAL_BOUND):
			world_grid[i].append(Tile.new())

	just_walls()
	
	for room in active_rooms:
		var room_count = active_rooms[room]
		for ct in range(room_count):
			var upperl_y = randi_range(0, VERTICAL_BOUND - room_data[room].y)
			var upperl_x = randi_range(0, HORIZONTAL_BOUND - room_data[room].x)
			
			var up_left_corner = Vector2i(upperl_x, upperl_y)
			var current_room = Room.new(room, up_left_corner)
			
			for y in range(upperl_y, upperl_y + current_room.room_dimensions.y):
				for x in range(upperl_x, upperl_x + current_room.room_dimensions.x):
					choose_tile(current_room, Vector2(x, y), world_grid[y][x].tile_type)
					
					
			current_room.queue_free()
	
	# fills the extra tiles
	#for i in range(VERTICAL_BOUND):
		#for j in range(HORIZONTAL_BOUND):
			#if world_grid[i][j].tile_type != 'r' and world_grid[i][j].tile_type not in abbr_walls:
				#fill_tile(Vector2(j, i))

func move(xy : Vector2):
	# is player trying to go oob?
	if xy.x < 0 or xy.x == HORIZONTAL_BOUND or xy.y < 0 or xy.y == VERTICAL_BOUND:
		return false
	
	# checks position that player wants to go to
	var p_position = world_grid[int(xy.y)][int(xy.x)]
	# if it's a wall,
	if p_position.tile_type in abbr_walls:
		# attack it
		if player.shovel():
			if p_position.health == 0:
				# make it a floor
				p_position.tile_type = 'f'
				tile_map.set_cell(Vector2(xy.x, xy.y), 0, Vector2(10, 1))
			else:
				p_position.health -= 1
			
	# returns if it's steppable
	return p_position.tile_type not in abbr_walls

func _ready():
	prepare_world_grid()
