class_name StandingEnemy
extends StaticBody3D

func _ready() -> void:
	rotation_degrees.y = randi_range(-180,180)

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.game_end_ui(false)

func _physics_process(delta: float) -> void:
	var rot : Vector3 = $CSGSphere3D.rotation_degrees
	rot.y = fposmod(rot.y + 60 * delta, 360.0)
	$CSGSphere3D.rotation_degrees = rot
