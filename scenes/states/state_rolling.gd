extends PlayerState

var move
@export var roll_spd = 250
@export var roll_time = 0.35
@export var invincble_time = 0.45

@onready var animation_player :AnimationPlayer = get_parent().get_parent().get_node("AnimationPlayer")

#@onready var face: AnimatedSprite = player.get_node("Sprite/Face")
var next_state

#var roll_sfx = preload("res://sounds/sfx/dice_roll.wav")


func _enter(args := [Vector2.ZERO]):
	# play sound
	#Sound.play_sfx(roll_sfx)
	# set invincibility
	player.set_invincible(invincble_time)
	
	# get move
	move = args[0]
	$RollTime.wait_time = roll_time
	$RollTime.start()
	#face.playing = true
	animation_player.play("pigroll")
	# reroll player weapon
	next_state = "state_moving"
	

func _exit(args := []):
	#player.shield.visible = false
	pass


func _game_logic(delta):
	player.velocity = move * roll_spd
	#player.get_node().rotation_degrees += 1440 * delta


	


func _on_roll_time_timeout():
	machine.change_state(next_state)
