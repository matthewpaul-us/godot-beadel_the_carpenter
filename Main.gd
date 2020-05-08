extends Node2D

export(int, 15, 120) var time_for_level

onready var eaten_viewport := $EatenViewport
onready var beadel_biter := $EatenViewport/BeadelHead
onready var symbol := $Symbol
onready var beadel := $Beadel
onready var score_keeper := $ScoreKeeper

onready var _level_timer := $PlayTimer
onready var _brain := $StateMachine
onready var _gui := $GUI

func _ready():
	beadel.beadel_head = beadel_biter

	score_keeper.viewport = eaten_viewport
	score_keeper.symbol = symbol

func _process(delta):
	_gui.set_time_left(_level_timer.time_left)


func set_timer_active(b : bool):
	if b:
		_level_timer.start(time_for_level)
	else:
		_level_timer.stop()


func _on_PlayTimer_timeout():
	_brain.set_state("end_game")

func play_end_game():
	var percent_complete = score_keeper.get_percent_finished()
	var percent_complete_money = percent_complete * 7500

	var time_taken = time_for_level - _level_timer.time_left
	var time_taken_money = _level_timer.time_left * 500

	_gui.show_receipt(percent_complete, percent_complete_money,
		time_taken, time_taken_money)


func _on_ScoreKeeper_compare_finished():
	_gui.set_percent_complete(score_keeper.get_percent_finished())
