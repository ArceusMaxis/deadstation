extends Control

@onready var playb: Button = $HBoxContainer/Play
@onready var creditsb: Button = $HBoxContainer/Credits
@onready var quitb: Button = $HBoxContainer/Quit
@onready var credbackb: Button = $creditsscreen/backb
@onready var creditsscreen: Control = $creditsscreen

func _ready() -> void:
	playb.pressed.connect(playpressed)
	creditsb.pressed.connect(creditspressed)
	quitb.pressed.connect(get_tree().quit)
	credbackb.pressed.connect(creditspressed)

func playpressed():
	get_tree().change_scene_to_file("res://scenes/intro_movie.tscn")

func creditspressed():
	creditsscreen.visible = !creditsscreen.visible
