extends CanvasLayer

onready var _receipt := $Receipt
onready var _time_left_label := $TimeLeftLabel
onready var _percent_complete_label := $PercentCompleteLabel

func set_time_left(seconds_left : float):
	var minutes = int(seconds_left / 60)
	var seconds = int(seconds_left) % 60

	_time_left_label.text = '%02d:%02d' % [minutes, seconds]

func set_percent_complete(percent_complete : float):
	_percent_complete_label.text = '%d.1%%' % (percent_complete * 100.0)

func show_receipt(percent_complete : float, percent_complete_money : float,
	time_taken_seconds : float, time_taken_money : float):
		_receipt.set_percent_complete(percent_complete, percent_complete_money)
		_receipt.set_time_taken(time_taken_seconds, time_taken_money)

		_receipt.update_subtotal()
		_receipt.update_tax()
		_receipt.update_total()
		_receipt.show()
