extends CharacterBody2D

@export var speed = 100
@onready var world_map = $"../world_map"
var shovels = 50
var current_tile = Vector2i(10, 10)

func get_input():
	var dir = Vector2i.ZERO
	if Input.is_action_just_pressed("ui_left"):
		dir = Vector2i.LEFT
	elif Input.is_action_just_pressed("ui_right"):
		dir = Vector2i.RIGHT
	elif Input.is_action_just_pressed("ui_up"):
		dir = Vector2i.UP
	elif Input.is_action_just_pressed("ui_down"):
		dir = Vector2i.DOWN

	if dir != Vector2i.ZERO and world_map.move(current_tile + dir):
		current_tile += dir
	
	
func shovel():
	shovels -= 1

func _physics_process(_delta):
	get_input()
	position = current_tile * 16
