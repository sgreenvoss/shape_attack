extends CharacterBody2D

@export var speed = 100
@onready var world_map = $"../world_map"
@onready var shovel_count = $Camera2D/shovel_count
@onready var class_data = $Class
@onready var audio_stream = $AudioStreamPlayer2D

#TEMP
@onready var tile_map_layer = $"../TileMapLayer"


var shovels = 50
var current_tile = Vector2i(10, 10)
var facing = 'up'
@export var char_class = 'thief'
var cooldown
var dmg
var timer

func _ready():
	cooldown = class_data.attack_data[char_class]['cooldown']
	dmg = class_data.attack_data[char_class]['dmg']
	timer = 0

func get_input():
	var dir = Vector2i.ZERO
	if Input.is_action_just_pressed('ui_accept'):
		timer += 1
		attack()
		return
	if Input.is_action_just_pressed("ui_left"):
		timer += 1
		facing = 'left'
		dir = Vector2i.LEFT
	elif Input.is_action_just_pressed("ui_right"):
		timer += 1
		facing = 'right'
		dir = Vector2i.RIGHT
	elif Input.is_action_just_pressed("ui_up"):
		timer += 1
		facing = 'up'
		dir = Vector2i.UP
	elif Input.is_action_just_pressed("ui_down"):
		timer += 1
		facing = 'down'
		dir = Vector2i.DOWN

	if dir != Vector2i.ZERO and world_map.move(current_tile + dir):
		current_tile += dir
	
	
func shovel():
	if shovels == 0:
		shovel_count.text = 'tired :('
		return false
	else:
		audio_stream.play()
		shovels -= 1
		shovel_count.text = str(shovels)
		return true
	
func get_attack_tiles():
	var pattern = class_data.attack_patterns[char_class][facing]
	var targets = []
	for offset in pattern:
		targets.append(current_tile + offset)
	return targets
	
func attack():
	if timer >= cooldown:
		for tile in get_attack_tiles():
			tile_map_layer.set_cell(tile, 0, Vector2(5, 11))
		timer = 0
	else:
		print('cooldown')

func _physics_process(_delta):
	get_input()
	position = current_tile * 16
