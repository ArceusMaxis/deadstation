extends Area3D

var player = null

func _on_body_entered(body):
	if body.is_in_group("player"):
		player = body
		player.hudlabel.visible = true
		player.hudlabel.text = " [Left Click] to Broadcast the 'Plan'"
		await get_tree().create_timer(2).timeout
		if player != null:
			player.hudlabel.text = ""
			player.hudlabel.visible = false

func _input(event):
	if player:
		if event.is_action_pressed("fire"):
			get_tree().change_scene_to_file("res://scenes/antenna_ending_movie.tscn")
