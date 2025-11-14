extends CharacterBody3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var speed = 4
var jump_speed = 4
var mouse_sensitivity = 0.008

@onready var cam : Camera3D = $Camera3D
@onready var winl: Label = $CanvasLayer/winl
@onready var losel: Label = $CanvasLayer/losel
@onready var flashlight: SpotLight3D = $Camera3D/Flashlight
@onready var animplayer: AnimationPlayer = $AnimationPlayer
@onready var hudlabel: Label = $CanvasLayer/hudlabel

var tutorial_complete : bool = false

func  _ready() -> void:
	animplayer.play("headbob")
	winl.visible = false
	losel.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	velocity.y += -gravity * delta
	var input = Input.get_vector("left", "right", "forward", "back")
	var movement_dir = transform.basis * Vector3(input.x, 0, input.y).normalized()
	if movement_dir:
		if animplayer.speed_scale != 1.0:
			animplayer.speed_scale = 1.0
		velocity.x = movement_dir.x * speed
		velocity.z = movement_dir.z * speed
	else:
		if animplayer.speed_scale != 0.0:
			animplayer.speed_scale = 0.0
		velocity.x = movement_dir.x * speed
		velocity.z = movement_dir.z * speed

	move_and_slide()
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_speed

func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		cam.rotate_x(-event.relative.y * mouse_sensitivity)
		cam.rotation.x = clampf(cam.rotation.x, -deg_to_rad(70), deg_to_rad(70))
	if event.is_action_pressed("flashlight"):
		flashlight.visible = !flashlight.visible

func game_end_ui(win : bool) -> void:
	if win:
		winl.visible = true
		losel.visible = false
	else:
		losel.visible = true
		winl.visible = false
