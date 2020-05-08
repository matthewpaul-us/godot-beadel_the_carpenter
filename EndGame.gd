extends Control

onready var _money_progress := $TextureProgress
onready var _money_label := $MoneyLabel
onready var _tween := $Tween
onready var _win_label := $WinLabel

func _ready():
	Globals.money_earned = 67491
	_tween.interpolate_method(self, 'set_money', 0, Globals.money_earned,
		5, Tween.TRANS_CIRC, Tween.EASE_OUT)
	_tween.start()

func _process(delta):
	if not _tween.is_active():
		show_win()

func set_money(m : float):
	_money_progress.value = m
	_money_label.text = _format_money(m)

func show_win():
	_win_label.show()


func _format_money(m : float):
	return '$%d' % m


func _on_MenuButton_pressed():
	get_tree().change_scene("res://MainMenu.tscn")
