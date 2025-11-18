extends Node3D

func _ready() -> void:
	rotation_degrees.y = randi_range(0,360)
	while true:
		await get_tree().create_timer(randf_range(15.0, 20.0)).timeout
		rotation_degrees.y = randi_range(0,360)
