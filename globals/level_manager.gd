extends Node

func get_num_enemies():
	# level 1: no enemies
	# level 2-3: 1/room
	# level 4-5: 2/room
	# level 6-8: 3/room
	# level 9-10: 4/room
	# level 11+: 5/room
	var lvl = Globals.cur_lvl
	if lvl < 2:
		return 0
	elif lvl < 4:
		return 1
	elif lvl < 6:
		return 2
	elif lvl < 9:
		return 3
	elif lvl < 11:
		return 4
	else:
		return 5

func get_num_rooms():
	# level 1: 15 rooms
	# level 2-3: 20 rooms
	# level 4-5: 25 rooms
	# level 6-8: 30 rooms
	# level 9-10: 40 rooms
	# level 11+: lvl * 5 rooms
	var lvl = Globals.cur_lvl
	if lvl < 1:
		return 15
	elif lvl < 4:
		return 20
	elif lvl < 6:
		return 25
	elif lvl < 9:
		return 30
	elif lvl < 11:
		return 40
	else:
		return lvl * 5
