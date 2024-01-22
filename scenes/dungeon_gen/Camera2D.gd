extends Camera2D

func _ready():
	Globals.room_entered.connect(func(room):
		global_position = room.global_position
		print("moving camera")
	)
