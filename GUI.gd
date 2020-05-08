extends CanvasLayer

signal next_level_pressed

onready var _receipt := $Receipt
onready var _time_left_label := $TimeLeftLabel
onready var _percent_complete_label := $PercentCompleteLabel
onready var _message := $MainMessage
onready var _anim := $AnimationPlayer

func _ready():
	_anim.play("timer")

func set_time_left(seconds_left : float):
	var minutes = int(seconds_left / 60)
	var seconds = int(seconds_left) % 60

	_time_left_label.text = '%02d:%02d' % [minutes, seconds]

func set_percent_complete(percent_complete : float):
	_percent_complete_label.text = '%d%%' % (percent_complete * 100.0)

func show_receipt(percent_complete : float, percent_complete_money : float,
	time_taken_seconds : float, time_taken_money : float,
	reference_pic : Texture, eaten_pic : Texture):
		_receipt.set_reference_picture(reference_pic)
		_receipt.set_actual_picture(eaten_pic)

		_receipt.set_percent_complete(percent_complete, percent_complete_money)
		_receipt.set_time_taken(time_taken_seconds, time_taken_money)

		_receipt.update_subtotal()
		_receipt.update_tax()
		_receipt.update_total()
		_receipt.show()

func show_message(message : String, time_to_show : float):
	_message.text = message
	_message.show()
	yield(get_tree().create_timer(time_to_show), "timeout")
	_message.hide()


func _on_Receipt_next_level_pressed():
	emit_signal("next_level_pressed")
