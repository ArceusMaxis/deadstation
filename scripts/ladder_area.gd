extends Area3D

var player = null
var is_climbing = false
var climb_speed = 2.4

func _on_body_entered(body):
	if body.is_in_group("player"):
		player = body
		player.hudlabel.visible = true
		player.hudlabel.text = " [Left Click] to Climb"
		await get_tree().create_timer(2).timeout
		if player != null:
			player.hudlabel.text = ""
			player.hudlabel.visible = false

func _on_body_exited(body):
	if body.is_in_group("player"):
		if is_climbing:
			release_player()
		player = null

func _input(event):
	if player and not is_climbing:
		if event.is_action_pressed("fire"):
			$"../../../Player/Buildup".play()
			start_climbing()
	
	if is_climbing:
		if event.is_action_pressed("jump"):
			release_player()

func _physics_process(delta):
	if is_climbing and player:
		player.global_position.x = global_position.x
		player.global_position.z = global_position.z
		
		player.velocity = Vector3.ZERO
		
		if Input.is_action_pressed("forward"):
			player.velocity.y = climb_speed
		elif Input.is_action_pressed("back"):
			player.velocity.y = -climb_speed
		
		player.move_and_slide()

func start_climbing():
	is_climbing = true
	player.gravity = 0

func release_player():
	is_climbing = false
	player.gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
	player = null
