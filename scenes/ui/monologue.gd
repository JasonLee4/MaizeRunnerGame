extends Control

const MAX_WIDTH = 128
var text = ""
var letter_index = 0

var letter_time = 0.03
var space_time = 0.06
var punctuation_time = 0.2

var displaying = false

@onready var label = $Label
@onready var timer = $Timer

func display_text(text_to_display):
	if displaying:
		return
	displaying = true
	letter_index = 0
	text = text_to_display
	##label.text = text_to_display
	#
	#await resized
	#custom_minimum_size.x = min(size.x, MAX_WIDTH)
	#
	#if size.x > MAX_WIDTH:
		#label.autowrap_mode = TextServer.AUTOWRAP_WORD
		#await resized # await for x resize
		#await resized # await for y resize
		#custom_minimum_size.y = size.y
	#
	#global_position.x -= size.x / 2
	#global_position.y -= size.y + 24
	print("display text")
	label.text = ""
	if text != "":
		_display_letter()

func _display_letter():
	print("display letter")
	if letter_index < text.length():
		label.text += text[letter_index]
	
	letter_index += 1
	if letter_index >= text.length():
		await(get_tree().create_timer(2).timeout)
		label.text = ""
		displaying = false
		return
	match text[letter_index]:
		"!", ",", ".", "?":
			timer.start(punctuation_time)
		" ":
			timer.start(space_time)
		_:
			timer.start(letter_time)

func _on_timer_timeout():
	_display_letter()
