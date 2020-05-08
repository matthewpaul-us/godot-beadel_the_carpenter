extends Node2D

export(int, 15, 120) var time_for_level := 15
export(String) var next_level

onready var eaten_viewport := $EatenViewport
onready var symbol := $Symbol
onready var beadel := $Beadel
onready var score_keeper := $ScoreKeeper

onready var _level_timer := $PlayTimer
onready var _brain := $StateMachine
onready var _gui := $GUI
onready var _win_music := $WinMusic
onready var _wood := $WoodSurface

func _ready():
	beadel.connect("eating_started", eaten_viewport, "_on_Beadel_eating_started")

	beadel.beadel_head = eaten_viewport.beetle_head

	score_keeper.viewport = eaten_viewport
	score_keeper.symbol = symbol

	_wood.material.set_shader_param("symbol_mask", symbol.texture)

	_level_timer.wait_time = time_for_level
	_gui.set_time_left(time_for_level)

func update_time():
	_gui.set_time_left(_level_timer.time_left)

func set_timer_active(b : bool):
	if b:
		_level_timer.start(time_for_level)
	else:
		_level_timer.stop()


func _on_PlayTimer_timeout():
	_brain.set_state("end_game")

func play_intro():
	_gui.show_message("Ready", 1.5)
	yield(get_tree().create_timer(2), "timeout")

	_gui.show_message("Set", 1.5)
	yield(get_tree().create_timer(3), "timeout")

	_gui.show_message("GO!", 1)

func play_game():
	beadel.start_play()

func play_end_game():
	beadel.stop_play()
	_win_music.play()

	var percent_complete = score_keeper.get_percent_finished()
	var percent_complete_money = percent_complete * 7500

	var time_taken = time_for_level - _level_timer.time_left
	var time_taken_money = _level_timer.time_left * 500

	var symbol_texture = symbol.texture
	var eaten_texture = eaten_viewport.get_texture()
	_gui.show_receipt(percent_complete, percent_complete_money,
		time_taken, time_taken_money,
		symbol_texture, eaten_texture)


func _on_ScoreKeeper_compare_finished():
	_gui.set_percent_complete(score_keeper.get_percent_finished())


func _on_GUI_next_level_pressed():
	get_tree().change_scene(next_level)
