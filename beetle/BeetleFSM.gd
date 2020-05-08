extends "res://assets/scripts/StateMachine.gd"

func _ready():
	add_state("idle")
	add_state("walking_forward")
	add_state("walking_backward")
	add_state("eating")
	call_deferred('set_state', 'idle')

func process_state(delta):
	# We always want to be able to turn
	if Input.is_action_pressed("turn_right"):
		parent.rotate(parent.turn_speed * delta)

	if Input.is_action_pressed("turn_left"):
		parent.rotate(-parent.turn_speed * delta)

	match state:
		"eating":
			parent._velocity = parent._forward() * parent.eat_speed

		"walking_forward":
			parent._velocity = parent._forward() * parent.move_speed

		"walking_backward":
			parent._velocity = -parent._forward() * parent.move_speed
	pass

func process_transition(delta):
	match state:
		"idle":
			if Input.is_action_pressed("eat"):
				return "eating"

			if Input.is_action_pressed("go_forward"):
				return "walking_forward"

			if Input.is_action_pressed("go_backward"):
				return "walking_backward"

		"walking_forward":
			if Input.is_action_pressed("eat"):
				return "eating"
			if not Input.is_action_pressed("go_forward"):
				return "idle"

		"walking_backward":
			if Input.is_action_pressed("eat"):
				return "eating"
			if not Input.is_action_pressed("go_backward"):
				return "idle"

		"eating":
			if not Input.is_action_pressed("eat"):
				return "idle"

	return null

func enter_state(new_state, old_state):
	if new_state == "walking_forward" or new_state == "walking_backward":
		parent.walk()

	if new_state == "eating":
		parent.emit_signal("eating_started")
		parent.eat()

	if new_state == "idle":
		parent._velocity = Vector2.ZERO
		parent.stop_animation()

func exit_state(old_state, new_state):
	if old_state == "eating":
		parent.emit_signal("eating_finished")
		parent.stop_eat()

	if old_state in ["walking_forward", "walking_backward"]:
		parent.stop_walk()
