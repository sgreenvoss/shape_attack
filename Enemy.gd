extends Node2D
@onready var world_map = $"../world_map"

var attack_rate
var current_pos : Vector2i = Vector2i(10, 5)
var move_dir = 1

func take_turn():
	pass
	
func move():
	var move_inc = Vector2i(0, move_dir)
	if world_map.valid_space(current_pos + move_inc):
		current_pos += move_inc
	else:
		move_dir = -move_dir
	position = current_pos * 16
	
func attack():
	pass
	
var timer = 0
var limit = .5

func _process(delta):
	timer += delta
	if timer > limit:
		timer = 0
		move()
