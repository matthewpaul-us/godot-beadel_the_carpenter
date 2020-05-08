extends KinematicBody2D

signal eating_started
signal eating_finished

export(float) var eat_speed := 75.0
export(float) var move_speed := 200.0
export(float) var turn_speed := 3.0

onready var _anim := $AnimationPlayer
onready var _eat_sound := $EatSound
onready var _walk_sound := $WalkSound
onready var _body := $Body
onready var _fsm := $StateMachine

var beadel_head
var _velocity := Vector2.ZERO
var _was_eating := false


func _physics_process(delta):
	move_and_collide(_velocity * delta)

	var body_size = _body.get_rect().size
	var viewport_size = get_viewport_rect().size
	if position.x < (0 - body_size.x):
		position.x = viewport_size.x
	elif position.x > (viewport_size.x + body_size.x):
		position.x = 0

	if position.y < (0 - body_size.y):
		position.y = viewport_size.y
	elif position.y > (viewport_size.y + body_size.y):
		position.y = 0

	if beadel_head:
		beadel_head.global_position = $BeetleHead.global_position
		beadel_head.global_rotation = $BeetleHead.global_rotation

func walk():
	_anim.play("walk")
	_walk_sound.play()

func stop_walk():
	_walk_sound.stop()

func eat():
	_anim.play("eat")
	_eat_sound.play()
	_walk_sound.play()
	if beadel_head:
			beadel_head.show()

func stop_eat():
	_eat_sound.stop()
	_walk_sound.stop()
	if beadel_head:
			beadel_head.hide()

func stop_animation():
	_anim.stop()

func start_play():
	_fsm.set_state('idle')

func stop_play():
	_fsm.set_state('stopped')

func _forward():
	return Vector2(0, -1).rotated(rotation).normalized()
