extends Node

signal health_change

var health = 5:
	get:
		return health
	set(value):
		health = value
		health_change.emit()
