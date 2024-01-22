extends SubViewport

@onready var tilemap = $TileMap

@onready var health_counter: HBoxContainer = $HealthCounter/HBoxContainer

func _ready():
	Globals.dungeon_created.connect(
		func(borders: Rect2, room_coords):
			# update minimap
			var grid_size = borders.size
			var top_left = borders.position
			print("updating minimap")
			
			# make everything dark
			for i in range(grid_size.x):
				for j in range(grid_size.y):
					var x = Vector2.RIGHT * i
					var y = Vector2.DOWN * j
					var pos = top_left + x + y
					if pos in room_coords:
						if pos == room_coords[0]:
							tilemap.set_cell(0, pos-top_left, 0, Vector2i(2,0))
						elif pos == room_coords[-1]:
							tilemap.set_cell(0, pos-top_left, 0, Vector2i(3,0))
						else:
							tilemap.set_cell(0, pos-top_left, 0, Vector2i(1,0))
					else:
						tilemap.set_cell(0, pos-top_left, 0, Vector2i(0,0))
	)		
