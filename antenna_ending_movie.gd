extends Control

@onready var back: Button = $Back

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	back.pressed.connect(backb)

func backb():
	get_tree().change_scene_to_file("res://scenes/mainmenu.tscn")
