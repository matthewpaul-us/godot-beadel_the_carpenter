extends KinematicBody2D

signal eating_started
signal eating_finished

export(float) var eat_speed := 75.0
export(float) var move_speed := 200.0
export(float) var turn_speed := 3.0

onready var _anim := $AnimationPlayer

var beadel_head
var _velocity := Vector2.ZERO
var _was_eating := false


func _physics_process(delta):
#	if Input.is_action_pressed("eat"):
#		if not _was_eating:
#			emit_signal("eating_started")
#			_was_eating = true
#
#		_velocity = _forward() * eat_speed
#
#	else:
#		if _was_eating:
#			emit_signal("eating_finished")
#			_was_eating = false
#
#		_velocity = Vector2.ZERO
#		if beadel_head:
#			beadel_head.hide()

	move_and_collide(_velocity * delta)

	if beadel_head:
		beadel_head.global_position = $BeetleHead.global_position
		beadel_head.global_rotation = $BeetleHead.global_rotation

func walk():
	_anim.play("walk")

func eat():
	_anim.play("eat")
	if beadel_head:
			beadel_head.show()

func stop_eat():
	if beadel_head:
			beadel_head.hide()

func stop_animation():
	_anim.stop()


func _forward():
	return Vector2(0, -1).rotated(rotation).normalized()
