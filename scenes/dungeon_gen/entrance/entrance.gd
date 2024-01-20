extends Area2D

signal player_moved_rooms

func _on_body_entered(body):
	player_moved_rooms.emit()
