extends Node3D

@onready var staticb: StaticBody3D = $StaticBody3D
@onready var area: Area3D = $Area3D
var freed = false

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and Autoload.tutorial_complete:
		get_tree().change_scene_to_file("res://scenes/townsquare.tscn")

func _physics_process(_delta: float) -> void:
	if Autoload.tutorial_complete and not freed and is_instance_valid(staticb):
		staticb.queue_free()
		freed = true
