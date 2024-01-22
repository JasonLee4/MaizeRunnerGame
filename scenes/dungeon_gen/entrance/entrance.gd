extends Area2D

@onready var tp_location = $Marker2D

func _on_body_entered(body):
	body.global_position = tp_location.global_position
