class_name StandingEnemy
extends StaticBody3D

var player = null

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.game_end_ui(false)
