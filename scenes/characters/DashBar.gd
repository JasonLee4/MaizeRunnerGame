extends ProgressBar

var roll_cooldown : Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Globals.pig.get_node("Sprite2D").flip_h == true:
		global_position.x = 690
	else:
		global_position.x = 560
	
	if is_instance_valid(roll_cooldown):
		if !roll_cooldown.is_stopped():
			visible = true
			max_value = roll_cooldown.wait_time
			value = roll_cooldown.time_left
		else:
			visible = false
	elif is_instance_valid(Globals.pig):
		roll_cooldown = Globals.pig.get_node("player_state_machine/state_moving/RollCooldown")
