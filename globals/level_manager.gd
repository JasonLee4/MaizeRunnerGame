extends Node

func get_num_enemies():
	# level 1: no enemies
	# level 2-5: 1/room
	# level 6-10: 2/room
	# level 11-14: 3/room
	# level 15-18: 4/room
	# level 19+: 5/room
	var lvl = Globals.cur_lvl
	if lvl < 2:
		return 0
	elif lvl < 6:
		return 1
	elif lvl < 11:
		return 2
	elif lvl < 15:
		return 3
	elif lvl < 19:
		return 4
	else:
		return 5

func get_num_rooms():
	# level 1-3: 15 rooms
	# level 4-8: 20 rooms
	# level 9-12: 25 rooms
	# level 13-15: 30 rooms
	# level 16+: 2 * level
	var lvl = Globals.cur_lvl
	if lvl < 4:
		return 15
	elif lvl < 9:
		return 20
	elif lvl < 13:
		return 25
	elif lvl < 16:
		return 30
	else:
		return lvl * 2
