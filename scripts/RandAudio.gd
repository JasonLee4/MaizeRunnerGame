extends AudioStreamPlayer
class_name RandAudio

@export var sounds: Array[Resource] = []

@onready var prev_index = -1

func play_rand_sound():
	var index = randi_range(0, sounds.size()-1)
	while index == prev_index:
		index = randi_range(0, sounds.size()-1)
	prev_index = index
	var audio = sounds[index]
	#print("playing audio number ", index)
	self.stream = audio
	self.play()
