extends ProgressBar

var curr_boss : boss

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func init_boss(new_boss):
	curr_boss = new_boss
	max_value = curr_boss.MAX_HEALTH
	value = curr_boss.health
	visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if curr_boss:
		value = curr_boss.health
