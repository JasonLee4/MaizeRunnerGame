extends Node

class_name Walker

const DIRECTIONS = [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN]

var position = Vector2.ZERO
var direction = Vector2.RIGHT
var borders = Rect2()
var step_history = []
var steps_since_turn = 0

func _init(starting_pos, new_borders):
	assert(new_borders.has_point(starting_pos))
	position = starting_pos
	step_history.append(position)
	borders = new_borders

func walk(steps):
	for step in steps:
		if randf() <= .45 or steps_since_turn >= 4:
			change_direction()
			
		if step():
			# ignore repeated steps
			if not position in step_history:
				step_history.append(position)
		else:
			change_direction()
	return step_history

func step():
	var target_pos = position + direction
	if borders.has_point(target_pos):
		steps_since_turn += 1
		position = target_pos
		return true
	return false

func change_direction():
	steps_since_turn = 0
	var directions = DIRECTIONS.duplicate()
	directions.erase(direction)
	directions.shuffle()
	direction = directions.pop_front()
	# change direction if unable to move in that direction
	while not borders.has_point(position + direction):
		direction = directions.pop_front()
