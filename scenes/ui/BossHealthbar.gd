extends ProgressBar

var curr_boss : boss
var finished : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	value = 100
	curr_boss = null
	finished = false

func init_boss(new_boss):
	curr_boss = new_boss
	max_value = curr_boss.MAX_HEALTH
	value = curr_boss.health
	visible = true
	
func boss_finish():
	curr_boss = null
	visible = false
	print(visible)
	finished = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !is_instance_valid(curr_boss) and !finished:
		boss_finish()
	if curr_boss and is_instance_valid(curr_boss):
		value = curr_boss.health
