extends Node

signal health_change

var health = 5:
	get:
		return health
	set(value):
		health = value
		health_change.emit()

signal room_entered(room)

signal dungeon_created(borders, grid)
