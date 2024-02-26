extends RandAudio

var wait_time : float
var waiting : bool

@export var min_wait_time = 5
@export var max_wait_time = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	waiting = false
	wait_time = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Playing audio
	if self.is_playing():
		pass
	#Finished audio
	elif not waiting and wait_time <= 0:
		waiting = true
		wait_time = randf_range(min_wait_time, max_wait_time)
	#Done waiting
	elif waiting and wait_time <= 0:
		waiting = false
		play_rand_sound()
	#Currently waiting
	elif waiting and wait_time > 0:
		wait_time -= delta
