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
	
func boss_finish():
	curr_boss = null
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if curr_boss:
		value = curr_boss.health
	if value <= 0:
		boss_finish()
