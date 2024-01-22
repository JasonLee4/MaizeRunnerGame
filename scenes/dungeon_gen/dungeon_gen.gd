extends Node2D

enum RoomType {Start, End, Combat}

var rect_room = preload("res://scenes/dungeon_gen/rooms/rect_room.tscn")
var player = preload("res://scenes/characters/pig.tscn").instantiate()

const grid_size = Vector2(5, 5)
const top_left_pos = Vector2(-2, -2)
const borders = Rect2(top_left_pos, grid_size)
const starting_pos = Vector2(0, 0)
const num_steps = 8

func _ready():
	generate_level()
	add_child(player)

func add_room(position: Vector2):
	var scaled_pos = Vector2(position.x*560, position.y*432)
	var new_room = rect_room.instantiate()
	new_room.global_position = scaled_pos
	add_child(new_room)
		
func generate_level():
	var walker = Walker.new(starting_pos, borders)
	var grid = walker.walk(num_steps)
	walker.queue_free()
	print(grid)
	for pos in grid:
		add_room(pos)
	Globals.dungeon_created.emit(borders, grid)
	
