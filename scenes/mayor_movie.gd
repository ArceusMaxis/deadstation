extends Control
@onready var ant: Button = $antenna_ending
@onready var hau: Button = $haul_ass_ending

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	ant.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/ending_antenna.tscn"))
	hau.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/mayor_movie.tscn")) #change needed
	await get_tree().create_timer(5).timeout #will be exact time as of movie
	ant.visible = true
	hau.visible = true
