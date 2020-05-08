extends Node

signal compare_started
signal compare_finished

export(Vector2) var compare_size := Vector2(128, 75)

var pixels_correct : int
var pixels_incorrect : int
var pixels_correct_line : int
var pixels_correct_offline : int
var pixels_incorrect_line : int
var pixels_incorrect_offline : int

var viewport : Viewport
var symbol : Sprite
var should_save_textures := false

var _should_start_compare := true
var _is_active := false


func _ready():
	call_deferred('set_active', true)
	var c = Color.white.v
	var d = Color.black.v
	pass

func _physics_process(delta):
	if Input.is_action_just_pressed("enable_debug"):
		should_save_textures = true


func _process(delta):
	if _is_active and _should_start_compare:
		emit_signal("compare_started")

		_should_start_compare = false
		var texture_data = viewport.get_texture().get_data()

		yield(get_tree(), "idle_frame")

		texture_data.resize(compare_size.x, compare_size.y, Image.INTERPOLATE_BILINEAR)
		if should_save_textures:
			texture_data.save_png("chewed.png")
		texture_data.lock()

		var symbol_data = symbol.texture.get_data()

		yield(get_tree(), "idle_frame")

		symbol_data.resize(compare_size.x, compare_size.y, Image.INTERPOLATE_BILINEAR)
		if should_save_textures:
			symbol_data.save_png("symbol.png")
		symbol_data.lock()

		var num_correct = 0
		var num_incorrect = 0
		var num_correct_in_line := 0 # pixels on the piece that were correctly munched
		var num_correct_out_line := 0 # pixels outside the piece that were correctly not munched
		var num_incorrect_in_line := 0 # pixels missed on the line
		var num_incorrect_out_line := 0 # pixels incorrectly munched outside the line

		for x in range(compare_size.x):
			for y in range(compare_size.y):
				var expected = _posterize(symbol_data.get_pixel(x, y))
				var actual = _posterize(texture_data.get_pixel(x, y))

				expected = _posterize(expected)
				actual = _posterize(actual)

				if expected == actual:
					num_correct += 1
					if expected != Color.white:
						num_correct_in_line += 1
					else:
						num_correct_out_line += 1
				else:
					num_incorrect += 1
					if expected != Color.white:
						num_incorrect_in_line += 1
					else:
						num_incorrect_out_line += 1

		pixels_correct = num_correct
		pixels_incorrect = num_incorrect
		pixels_correct_line = num_correct_in_line
		pixels_correct_offline = num_correct_out_line
		pixels_incorrect_line = num_incorrect_in_line
		pixels_incorrect_offline = num_incorrect_out_line

		emit_signal("compare_finished")
		_should_start_compare = true
		should_save_textures = false

func get_percent_finished():
	if (pixels_correct_line + pixels_incorrect_line) == 0:
		return 0

	return float(pixels_correct_line) / (pixels_correct_line + pixels_incorrect_line)

func set_active(b : bool):
	_is_active = b

func _posterize(c : Color) -> Color:
	var v = c.v
	if c.v > 0.5:
		return Color.white
	else:
		return Color.black
