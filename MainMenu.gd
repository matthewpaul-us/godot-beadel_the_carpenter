extends Node

onready var beetle := $Beadel
onready var eaten_viewport := $EatenViewport
onready var _anim := $AnimationPlayer

func _ready():
	beetle.connect("eating_started", eaten_viewport, "_on_Beadel_eating_started")
	beetle.call_deferred('start_play')

	beetle.beadel_head = eaten_viewport.beetle_head

	_anim.play("move_title_card")

func _on_Area2D_body_entered(body):
	get_tree().change_scene("res://levels/Level_01_Plug.tscn")
