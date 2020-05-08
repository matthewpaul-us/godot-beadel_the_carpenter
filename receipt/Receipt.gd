extends TextureRect

signal next_level_pressed

export(float, 0, 1, 0.005) var tax_rate = 0.095

onready var percent_complete_label := $PercentCompleteLabel
onready var percent_complete_money_label := $PercentCompleteMoneyLabel

onready var time_taken_label := $TimeTakenLabel
onready var time_taken_money_label := $TimeTakenMoneyLabel

onready var subtotal_label := $SubtotalLabel
onready var tax_label := $TaxLabel

onready var total_label := $TotalLabel

onready var _request_image := $RequestImage
onready var _fulfilled_image := $FulfilledImage

var _percent_complete_money := 0
var _time_taken_money := 0

func set_percent_complete(complete : float, money : float):
	percent_complete_label.text = '%d%%' % (complete * 100.0)
	percent_complete_money_label.text = _format_money(money)
	_percent_complete_money = int(money)

func set_time_taken(seconds : float, money : float):
	var minutes = int(seconds / 60)
	var secs = int(seconds) % 60

	time_taken_label.text = '%02d:%02d' % [minutes, seconds]
	time_taken_money_label.text = _format_money(money)
	_time_taken_money = int(money)

func update_subtotal():
	var subtotal = _percent_complete_money + _time_taken_money
	subtotal_label.text = _format_money(subtotal)

func update_tax():
	var tax = (_percent_complete_money + _time_taken_money) * tax_rate
	tax_label.text = _format_money(tax)

func update_total():
	var total = (_percent_complete_money + _time_taken_money) * (1 + tax_rate)
	total_label.text = _format_money(total)

func set_reference_picture(image : Texture):
	_request_image.texture = image
	pass

func set_actual_picture(image: Texture):
	_fulfilled_image.texture = image
	pass

func _format_money(m : float):
	return '$%d' % m


func _on_NextLevelButton_pressed():
	emit_signal("next_level_pressed")
