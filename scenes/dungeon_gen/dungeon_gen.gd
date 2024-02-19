extends Node2D
var Room = preload("res://scenes/dungeon_gen/rooms/rect_room.tscn")
var player_scene = preload("res://scenes/characters/pig.tscn")
var rat_enemy = preload("res://scenes/enemies/rat.tscn")
var ui_scene = preload("res://scenes/ui/ui.tscn")
var fireplace_scene = preload("res://scenes/objects/FirePlace.tscn")
var exit_scene = preload("res://scenes/objects/exit.tscn")
var wood_scene = preload("res://scenes/items/wood.tscn")
var apple_scene = preload("res://scenes/items/apple.tscn")
var key_scene = preload("res://scenes/items/key.tscn")

@onready var map = $TileMap
@onready var camera

@onready var num_rooms = LevelManager.get_num_rooms()
@onready var enemies_per_rm = LevelManager.get_num_enemies()

# room generation vars
const min_size = 4
const max_size = 7
const h_spread = 100
const cull_pct = .6
const tile_size = 32

var start_room = null
var key_room = null
var exit_room = null
var play_mode = false
var player = null
var path # AStar pathfinder to hold MST
var enemy_spawns = []

func _ready():
	seed("maizerunner".hash())
	print("Making rooms...")
	print(num_rooms)
	await make_rooms()
	print("Loading UI...")
	add_child(ui_scene.instantiate())
	print("Loading player...")
	load_player()
	print("Creating map...")
	make_map()
	print("Spawning enemies...")
	print(enemies_per_rm)
	spawn_enemies(enemies_per_rm)
	print("Spawn items...")
	spawn_items()
	# start game timer
	Globals.lvl_start.emit()
	$Ambiance.play()
	

func _process(_delta):
	queue_redraw()
	
func make_rooms():
	for i in range(num_rooms):
		var pos = Vector2(randi_range(-h_spread, h_spread),0)
		var r = Room.instantiate()
		var w = min_size + randi() % (max_size - min_size)
		var h = min_size + randi() % (max_size - min_size)
		r.make_room(pos, Vector2(w, h) * tile_size)
		$Rooms.add_child(r)
		
	# create center room
	var r = Room.instantiate()
	r.freeze = true
	#r.set_text("Start Room")
	r.make_room(Vector2(0,0), Vector2(10, 10) * tile_size)
	$Rooms.add_child(r)
	start_room = r
	
	# wait for rooms to stop moving
	await(get_tree().create_timer(1.1).timeout)
	
	# cull rooms
	var room_positions = []
	for room in $Rooms.get_children():
		if check_overlap(room, r) and room != r:
			room.queue_free()
		elif randf() < cull_pct and room != r:
			room.queue_free()
		else:
			room.freeze = true
			room_positions.append(room.position)
	#print(room_positions)
	# idle frame to make sure all rooms freeze
	await(get_tree().create_timer(.5).timeout)
	# generate MST
	path = find_mst(room_positions)

func load_player():
	player = player_scene.instantiate()
	add_child(player)
	Globals.pig = player
	player.position = start_room.position
	play_mode = true
	#camera = Camera2D.new()
	#
	#camera.set_script(load("res://scenes/levels/Camera.gd"))
	#
	#camera.zoom = Vector2(2.5,2.5)
	#player.add_child(camera)

func make_map():
	map.clear()
	find_key_exit_rooms()
	
	var full_rect = Rect2()
	for room in $Rooms.get_children():
		var r = Rect2(room.position-room.size, room.get_node("CollisionShape2D").shape.extents*2)
		full_rect = full_rect.merge(r)
		#print("merging room")
		#print(full_rect.size)
		
	var topleft = map.local_to_map(full_rect.position)
	var bottomright = map.local_to_map(full_rect.end)
	#print(topleft)
	#print(bottomright)
	const offset = 100
	for x in range(topleft.x-offset, bottomright.x+offset):
		for y in range(topleft.y-offset, bottomright.y+offset):
			# set background to grass
			# layer, coords, source_id, atlas_coords, alt_tile
			map.set_cell(0, Vector2i(x, y), 0, Vector2i(8,4), 0)
	
	# carve rooms and corridors
	var corridors = []
	for room in $Rooms.get_children():
		var s = (room.size / tile_size).floor()
		var pos = map.local_to_map(room.position)
		var ul = (room.position / tile_size).floor() - s
		# carve rooms
		for x in range(2, s.x * 2 - 1):
			for y in range(2, s.y * 2 - 1):
				#map.set_cell(0, Vector2i(ul.x + x, ul.y + y), 0, Vector2i(6,4), 0)
				map.set_cells_terrain_connect(0, [Vector2i(ul.x + x, ul.y + y)], 0, 0)

		# carve connection
		var p = path.get_closest_point(room.position)
		for conn in path.get_point_connections(p):
			if not conn in corridors:
				var start = map.local_to_map(path.get_point_position(p))
				var end = map.local_to_map(path.get_point_position(conn))
				carve_path(start, end)
		corridors.append(p)
	# add corn 
	var grass_tiles: Array[Vector2i] = map.get_used_cells_by_id(0, 0, Vector2i(8, 4), 0)
	for tile in grass_tiles:
		map.set_cell(1, tile, 0, Vector2i(2,0), 0)
	# add rocks / bones
	var dirt_tiles: Array[Vector2i] = map.get_used_cells_by_id(0, 0, Vector2i(6, 4), 0)
	for tile in dirt_tiles:
		var roll = randf()
		if roll < .05:
			#map.set_cells_terrain_connect(2, [tile], 1, 0)
			var rock = Vector2i(randi_range(0, 1), randi_range(0, 2))
			map.set_cell(2, tile, 1, rock, 0)
		elif roll < .1:
			var bones = Vector2i(randi_range(0, 1)*2, randi_range(0, 2))
			map.set_cell(2, tile, 2, bones, 0)

func spawn_enemies(enemies_per_rm):
	# generate enemy spawns
	for room in $Rooms.get_children():
		# don't spawn enemies in the start room
		if room == start_room:
			continue
		for i in range(enemies_per_rm):
			var rand_pt = room.get_rand_pt() + room.global_position
			enemy_spawns.append(rand_pt)
	# spawn just rats for now
	for spawn_pos in enemy_spawns:
		var rat = rat_enemy.instantiate()
		rat.global_position = spawn_pos
		$Enemies.add_child(rat)

func spawn_items():
	for room in $Rooms.get_children():
		var spawn_pos = room.get_rand_pt() + room.global_position
		if room == start_room:
			# spawn campfire in start room
			var fireplace = fireplace_scene.instantiate()
			fireplace.global_position = spawn_pos
			$Objects.add_child(fireplace)
		elif room == key_room:
			# spawn key in rightmost room
			var key = key_scene.instantiate()
			key.global_position = spawn_pos
			$Objects.add_child(key)
		elif room == exit_room:
			# spawn exit in leftmost room
			var exit = exit_scene.instantiate()
			exit.global_position = spawn_pos
			$Objects.add_child(exit)
		else:
			# spawn wood or apple
			var roll = randf()
			var item
			if roll < .7:
				item = wood_scene.instantiate()
			else:
				item = apple_scene.instantiate()
			item.global_position = spawn_pos
			$Objects.add_child(item)


### Helper functions ###
func carve_path(start, end):
	var difference_x = sign(end.x - start.x)
	var difference_y = sign(end.y - start.y)
	
	if difference_x == 0:
		difference_x = pow(-1.0, randi() % 2)
	if difference_y == 0:
		difference_y = pow(-1.0, randi() % 2)
		
	var x_over_y = start
	var y_over_x = end
	
	if randi() % 2 > 0:
		x_over_y = end
		y_over_x = start

	for x in range(start.x, end.x, difference_x):
		#map.set_cell(0, Vector2i(x, y_over_x.y), 0, Vector2i(6,4), 0)
		map.set_cells_terrain_connect(0, [Vector2i(x, y_over_x.y)], 0, 0)
	for y in range(start.y, end.y, difference_y):
		#map.set_cell(0, Vector2i(x_over_y.x, y), 0, Vector2i(6,4), 0)
		map.set_cells_terrain_connect(0, [Vector2i(x_over_y.x, y)], 0, 0)

func find_key_exit_rooms():
	var max_x = -INF
	var min_x = INF
	for room in $Rooms.get_children():
		if room.position.x > max_x:
			key_room = room
			max_x = room.position.x
		if room.position.x < min_x:
			exit_room = room
			min_x = room.position.x

func find_mst(nodes):
	# Prim's algorithm
	var path = AStar2D.new()
	path.add_point(path.get_available_point_id(), nodes.pop_front())
	
	while nodes:
		var min_dist = INF
		var min_pos = null
		var pos = null
		
		for p in path.get_point_ids():
			var p1 = path.get_point_position(p)
			
			for p2 in nodes:
				if p1.distance_to(p2) < min_dist:
					min_dist = p1.distance_to(p2)
					min_pos = p2
					pos = p1
			
		var n = path.get_available_point_id()
		path.add_point(n, min_pos)
		path.connect_points(path.get_closest_point(pos), n)
		nodes.erase(min_pos)
	return path

func check_overlap(room1, room2):
	var room1_rect = Rect2(room1.global_position, room1.size + Vector2(20,20))
	var room2_rect = Rect2(room2.global_position, room2.size + Vector2(20,20))
	return room1_rect.intersects(room2_rect)

func _input(event):
	pass
	#if event.is_action_pressed("reload"):
		#for n in $Rooms.get_children():
			#n.queue_free()
		#path = null
		#make_rooms()
		#map.clear()
		#if player:
			#player.queue_free()
	#if event.is_action_pressed("ui_focus_next"):
		#make_map()
		#print("making map")
	#if event.is_action_pressed("ui_cancel"):
		#camera.queue_free()
		#load_player()
	#if event.is_action_pressed("scroll_down"):
		#camera.zoom = camera.zoom - Vector2(0.1, 0.1)
	#if event.is_action_pressed("scroll_up"):
		#camera.zoom = camera.zoom + Vector2(0.1, 0.1)

#func _draw():
	#var color = Color.YELLOW
	#for room in $Rooms.get_children():
		#if room == start_room:
			#color = Color.LIGHT_GREEN
		#draw_rect(Rect2(room.position - room.size + room.size / 2, room.size ), color, false)

	#if path:
		#for p in path.get_point_ids():
			#for c in path.get_point_connections(p):
				#var pp = path.get_point_position(p)
				#var cc = path.get_point_position(c)
				#draw_line(pp, cc, Color(1, 0, 1), 10, true)

	#for spawn in enemy_spawns:
		#draw_rect(Rect2(spawn, Vector2(10,10)), Color.RED)
