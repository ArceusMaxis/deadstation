extends RigidBody3D

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		#play the end animation
		await get_tree().create_timer(2).timeout
		queue_free()
