extends Area3D


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.global_position = Vector3(18.474,86,-23.038)
