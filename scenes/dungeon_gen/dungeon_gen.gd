extends Node2D

enum RoomType {Start, End, Combat}

var start_room = preload("res://scenes/dungeon_gen/rooms/box_room.tscn").instantiate()
var room = preload("res://scenes/dungeon_gen/rooms/box_room.tscn")
var player = preload("res://scenes/characters/pig.tscn")

var grid_size = Vector2(5, 5)
var cur_grid_pos = Vector2(0, 0)
var grid = []

func _ready():
	init_grid()
	
	var room1 = room.instantiate()
	# add rooms to grid
	grid[0][0] = start_room
	grid[0][1] = room1
	# connect rooms
	start_room.set_entrances(false, true, false, false)
	room1.set_entrances(false, false, false, true)
	# spawn room
	add_child(grid[cur_grid_pos.x][cur_grid_pos.y])
	# spawn player in room
	start_room.spawn_player(player, CONST.Dir.West)
	
	start_room.enter_east.connect(_on_enter_east)
	room1.enter_west.connect(_on_enter_west)



func init_grid():
	for x in range(grid_size.x):
		var row = []
		for y in range(grid_size.y):
			row.append(null)
		grid.append(row)
		
func generate_dungeon():
	pass
	

func _on_enter_east():
	# teleport player
	var cur_room = grid[cur_grid_pos.x][cur_grid_pos.y]
	var next_room = grid[cur_grid_pos.x][cur_grid_pos.y+1]

	move_player(cur_room, next_room, CONST.Dir.West)
	
func _on_enter_west():
	# teleport player
	var cur_room = grid[cur_grid_pos.x][cur_grid_pos.y]
	var next_room = grid[cur_grid_pos.x][cur_grid_pos.y-1]

	move_player(cur_room, next_room, CONST.Dir.East)

func _on_enter_north():
	# teleport player
	var cur_room = grid[cur_grid_pos.x][cur_grid_pos.y]
	var next_room = grid[cur_grid_pos.x+1][cur_grid_pos.y]

	move_player(cur_room, next_room, CONST.Dir.South)
	
func _on_enter_south():
	# teleport player
	var cur_room = grid[cur_grid_pos.x][cur_grid_pos.y]
	var next_room = grid[cur_grid_pos.x+1][cur_grid_pos.y]

	move_player(cur_room, next_room,CONST.Dir.North)

func move_player(cur_room, next_room, direction: CONST.Dir):
	cur_room.visible = false
	cur_room.despawn_player()
	add_child(next_room)
	next_room.spawn_player(player, direction)
