extends Node

signal state_changed

onready var parent := get_parent()

var state = null setget set_state
var previous_state = null

var states = {}

func add_state(new_state : String):
	states[new_state] = new_state

func _physics_process(delta):
	if state != null:
		process_state(delta)

	var transition = process_transition(delta)

	if transition != null and transition != state:
		set_state(transition)

func process_state(delta):
	pass

func process_transition(delta):
	return null

func enter_state(new_state, old_state):
	pass

func exit_state(old_state, new_state):
	pass

func set_state(new_state):
	previous_state = state
	state = new_state

	if state != previous_state:
		emit_signal("state_changed", state)

	if previous_state != null:
		exit_state(previous_state, state)

	if state != null:
		enter_state(state, previous_state)
