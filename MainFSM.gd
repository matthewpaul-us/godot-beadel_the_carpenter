extends "res://assets/scripts/StateMachine.gd"

func _ready():
	add_state("intro")
	add_state("carve")
	add_state("end_game")
	call_deferred("set_state", "intro")

var time_to_wait := 0.0

func process_state(delta):
	match state:
		"intro":
			time_to_wait -= delta
		"carve":
			parent.update_time()
	pass

func process_transition(delta):
	match state:
		"intro":
			if time_to_wait <= 0:
				return "carve"
	return null

func enter_state(new_state, old_state):
	if new_state == states.intro:
		time_to_wait = 5
		parent.play_intro()

	if new_state == states.carve:
		parent.set_timer_active(true)
		parent.play_game()

	if new_state == states.end_game:
		parent.play_end_game()
	pass

func exit_state(old_state, new_state):
	if old_state == states.carve:
		parent.set_timer_active(false)
