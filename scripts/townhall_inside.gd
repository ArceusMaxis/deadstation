extends Area3D

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		get_tree().call_deferred("change_scene_to_file","res://scenes/town_act_2.tscn")
