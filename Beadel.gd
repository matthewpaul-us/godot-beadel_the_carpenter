extends KinematicBody2D

signal eating_started
signal eating_finished

export(float) var eat_speed := 75.0
export(float) var move_speed := 200.0
export(float) var turn_speed := 3.0

var beadel_head
var _velocity := Vector2.ZERO
var _was_eating := false

func _physics_process(delta):
	if Input.is_action_pressed("eat"):
		if not _was_eating:
			emit_signal("eating_started")
			_was_eating = true

		_velocity = _forward() * eat_speed
		if beadel_head:
			beadel_head.show()
	else:
		if _was_eating:
			emit_signal("eating_finished")
			_was_eating = false

		_velocity = Vector2.ZERO
		if beadel_head:
			beadel_head.hide()



		# Don't let them go forward/backward, it'll mess up the eating
		if Input.is_action_pressed("go_forward"):
			_velocity += _forward() * move_speed

		if Input.is_action_pressed("go_backward"):
			_velocity -= _forward() * move_speed

	if Input.is_action_pressed("turn_right"):
		rotate(turn_speed * delta)

	if Input.is_action_pressed("turn_left"):
		rotate(-turn_speed * delta)

	move_and_collide(_velocity * delta)

	if beadel_head:
		beadel_head.global_position = $BeetleHead.global_position
		beadel_head.global_rotation = $BeetleHead.global_rotation

func _forward():
	return Vector2(0, -1).rotated(rotation).normalized()
