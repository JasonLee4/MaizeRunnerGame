extends PlayerState





#func _game_logic(delta):
	#Globals.pig.velocity = Vector2(0,0)
	
func _enter(args := []) -> void:
	print("playing pig death")
	Globals.pig.get_node("AnimationPlayer").play("pigdeath")
	
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file("res://scenes/menus/end_screen.tscn")
	self.queue_free()
	
