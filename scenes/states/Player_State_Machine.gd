extends Node


# a node that controls a group of state nodes. Useful for tons of different systems
class_name Player_State_Machine


var possible_states = [] # an array of strings containing the name of every possible state
var selected_state: PlayerState # a refernce to whatever state is currently active
@export var starting_args = []  # arguments for the starting state
@export var starting_state = "state_moving" # a path to the starting state
@export var output_changes = false # whether state changes should be outputted to the debug console

signal state_changed(old_state, new_state) # emitted whenever a state is changed

signal game_logic_finished() # emitted whenever the state finishes running its game_logic function
signal transfer_logic_finished() # emitted whenever state finishes running its transfer logic

var parent # a reference to the state machine's parent


func _ready():
	# get parent
	parent = get_parent()

	# get all possible states
	for child in get_children():
		print("state child : " + child.name)
		possible_states.append(child.get_name())

	# start initial state
	change_state(starting_state, starting_args)


# changes the state to new_state. The enter_args array will be passed into the new state's _enter() function, while the exit_args array will be passed into the old state's _exit() function
# This function returns a boolean indicating if the state change was successful
# note: the old state's exit function is run before the new state's enter function 
# new_state - the state that should be entered into
# enter_args - any agruments that should be passed into the new state's _enter() method
# exit_args - any arguments that should be passed intot he old state's _exit() method
func change_state(new_state: String, enter_args := [], exit_args := []) -> bool:
	var old_name = "none"
	var new_name = "none"

	# check if the new state can be entered into
	if (get_state(new_state)._can_change()):
		# make sure there was an old state
		if selected_state != null:
			# have the old state exit
			# run exit function
			selected_state._exit(exit_args)
			
			
			# debug stuff
			old_name = selected_state.name
		#print("state changing testing...")
		# enter into the new state
		selected_state = get_state(new_state)
		selected_state._enter(enter_args)
		new_name = selected_state.name

		# output debug
		if output_changes:
			print("Switched from " + old_name + " to " + new_name)
		
		# emit signal
		emit_signal("state_changed", old_name, new_name)

		# return success
		return true
	else:
		if output_changes:
			print("State change failed")
		
		return false


# tells the state machine to process all of the states
# runs the state's game_logic and then runs its transfer_logic
func process_states(delta):
	selected_state._game_logic(delta)
	emit_signal("game_logic_finished")
	selected_state._transition_logic(possible_states)
	emit_signal("transfer_logic_finished")


func _get_configuration_warning():
	if starting_state == "":
		return "StateMachine requires a starting state to be set to work properly"
	
	return ""


# gets a reference to a state
# state_name - the name of the state as a string
func get_state(state_name: String) -> PlayerState:
	var state: PlayerState = get_node(state_name)
	return state


func _input(event):
	if selected_state != null:
		selected_state._active_input(event)
