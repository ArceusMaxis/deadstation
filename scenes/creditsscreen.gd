extends Control

@onready var chaakb: Button = $chaakb
@onready var evanb: Button = $evanb
@onready var livb: Button = $livb

func _ready() -> void:
	chaakb.pressed.connect(func(): OS.shell_open("https://chaak_007.itch.io/"))
	evanb.pressed.connect(func(): OS.shell_open("https://thneebdev.itch.io/"))
	livb.pressed.connect(func(): OS.shell_open("https://youtube.com"))
