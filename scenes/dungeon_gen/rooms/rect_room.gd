extends Node2D

func _ready():
	pass
	
func _on_player_detector_body_entered(body):
	print("player entered room!")
	Globals.room_entered.emit(self)
