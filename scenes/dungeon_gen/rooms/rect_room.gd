extends RigidBody2D

var size

func make_room(_pos, _size):
	position = _pos
	size = _size
	var s = RectangleShape2D.new()
	s.custom_solver_bias = .75
	s.size = size
	$CollisionShape2D.shape = s

func set_text(text):
	$Label.text = text

func get_rand_pt():
	# get a random point in the room
	var spawn_area = $CollisionShape2D.shape.extents
	var origin = $CollisionShape2D.position - spawn_area
	var x = randf_range(origin.x, spawn_area.x)
	var y = randf_range(origin.y, spawn_area.y)
	return Vector2(x, y)
	
	
