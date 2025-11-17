extends Control
@onready var continueb: Button = $Continue

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	continueb.pressed.connect(bucket)

func bucket(): 
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_parent().cursor.visible = true
	visible = false
