extends RigidBody3D

func _ready() -> void:
	await get_tree().create_timer(15).timeout
	call_deferred("queue_free")
