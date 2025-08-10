extends Node
class_name Tile

var tile_type
var health

func _init(tile='r', initial_health='0'):
	tile_type = tile
	health = initial_health

func revise(room : Room):
	tile_type = room.room_type
	health = room.health
