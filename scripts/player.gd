extends CharacterBody3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var speed = 4
var jump_speed = 4
var mouse_sensitivity = 0.008

@onready var cam : Camera3D = $Camera3D
@onready var losel: ColorRect = $CanvasLayer/losel
@onready var flashlight: SpotLight3D = $Camera3D/Flashlight
@onready var animplayer: AnimationPlayer = $AnimationPlayer
@onready var hudlabel: Label = $CanvasLayer/hudlabel
@onready var scannermodel: Node3D = $Camera3D/Hand/Scanner
@onready var flashlightmodel: Node3D = $Camera3D/Hand/Torch
@onready var flaregunmodel: Node3D = $Camera3D/Hand/FlareGun
@onready var cursor: Label = $CanvasLayer/Label
@onready var muzzle: Marker3D = $Camera3D/Hand/FlareGun/Marker3D
@onready var pause_menu: Control = $PauseMenu
@onready var led_1: CSGMesh3D = $Camera3D/Hand/Scanner/LED1
@onready var led_2: CSGMesh3D = $Camera3D/Hand/Scanner/LED2
@onready var led_3: CSGMesh3D = $Camera3D/Hand/Scanner/LED3
@onready var led_4: CSGMesh3D = $Camera3D/Hand/Scanner/LED4
@onready var led_5: CSGMesh3D = $Camera3D/Hand/Scanner/LED5
@onready var retryb: Button = $CanvasLayer/losel/retryb

@export var bullet_scn : PackedScene

func  _ready() -> void:
	retryb.pressed.connect(get_tree().reload_current_scene)
	hudlabel.visible = false
	cursor.visible = true
	animplayer.play("headbob")
	losel.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if get_parent().name == "Act2":
		hudlabel.visible = true
		hudlabel.text = " Lure Untethered with Flare gun (E)"
		await get_tree().create_timer(3).timeout
		hudlabel.text = " Use Scanner(Q) to find SOS source"
		await get_tree().create_timer(2).timeout
		hudlabel.text = " Don't try to fight the Untethered, its useless"
		await get_tree().create_timer(2).timeout
		hudlabel.text = " Goodluck, Charter 7"
		await get_tree().create_timer(2).timeout
		hudlabel.visible = false
	
	if get_parent().name == "Act3":
		hudlabel.visible = true
		hudlabel.text = " It's too dark in here"
		await get_tree().create_timer(3).timeout
		hudlabel.text = " Gonna have to use the flashlight"
		await get_tree().create_timer(2).timeout
		hudlabel.text = " And continue to scan for the signal"
		await get_tree().create_timer(2).timeout
		hudlabel.visible = false

func _physics_process(delta):
	update_scanner_LED()
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

var can_shoot = true

func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		cam.rotate_x(-event.relative.y * mouse_sensitivity)
		cam.rotation.x = clampf(cam.rotation.x, -deg_to_rad(70), deg_to_rad(70))
	if event.is_action_pressed("flashlight") and flashlight and flashlightmodel:
		flashlight.visible = !flashlight.visible
		flashlightmodel.visible = flashlight.visible
		if flashlight.visible and scannermodel and flaregunmodel:
			scannermodel.visible = false
			flaregunmodel.visible = false
	if event.is_action_pressed("scanner") and scannermodel:
		scannermodel.visible = !scannermodel.visible
		if scannermodel.visible:
			if flashlight:
				flashlight.visible = false
			if flashlightmodel:
				flashlightmodel.visible = false
			if flaregunmodel:
				flaregunmodel.visible = false
	if event.is_action_pressed("flaregun") and flaregunmodel:
		flaregunmodel.visible = !flaregunmodel.visible
		if flaregunmodel.visible:
			if flashlight:
				flashlight.visible = false
			if flashlightmodel:
				flashlightmodel.visible = false
			if scannermodel:
				scannermodel.visible = false
	if event.is_action_pressed("fire") and flaregunmodel.visible and bullet_scn and can_shoot:
		can_shoot = false
		var bullet = bullet_scn.instantiate()
		get_tree().current_scene.add_child(bullet)
		bullet.global_position = muzzle.global_position
		bullet.global_rotation = muzzle.global_rotation
		bullet.linear_velocity = muzzle.global_transform.basis.z * 20
		
		var original_rotation = flaregunmodel.rotation
		flaregunmodel.rotation_degrees += Vector3(0, 0, 30)
		var tween = get_tree().create_tween()
		tween.tween_property(flaregunmodel, "rotation", original_rotation, 0.3)
		
		await get_tree().create_timer(1).timeout
		can_shoot = true
	
	if event.is_action_pressed("pause"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		cursor.visible = false
		pause_menu.visible = true
		get_tree().paused = true

func game_end_ui(win : bool) -> void:
	if win:
		pass
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		losel.visible = true
	cursor.visible = false

func update_scanner_LED():
	if not scannermodel.visible:
		return
	
	led_1.visible = false
	led_2.visible = false
	led_3.visible = false
	led_4.visible = false
	led_5.visible = false
	
	var target = get_tree().get_first_node_in_group("target")
	if not target:
		return
	
	var distance = global_position.distance_to(target.global_position)
	
	if distance < 75:
		led_1.visible = true
	if distance < 50:
		led_2.visible = true
	if distance < 25:
		led_3.visible = true
	if distance < 15:
		led_4.visible = true
	if distance < 6:
		led_5.visible = true
