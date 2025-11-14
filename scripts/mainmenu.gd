extends Control

@onready var playb: Button = $HBoxContainer/Play
@onready var creditsb: Button = $HBoxContainer/Credits
@onready var settingsb: Button = $HBoxContainer/Settings
@onready var quitb: Button = $HBoxContainer/Quit

func _ready() -> void:
	playb.pressed.connect(playpressed)
	creditsb.pressed.connect(creditspressed)
	settingsb.pressed.connect(settingspressed)
	quitb.pressed.connect(get_tree().quit)

func playpressed():
	get_tree().change_scene_to_file("res://scenes/getready.tscn")

func creditspressed():
	pass

func settingspressed():
	pass
