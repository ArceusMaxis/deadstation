class_name MovingEnemy
extends StaticBody3D

var player = null
@onready var animplayer: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.game_end_ui(false)

func _physics_process(delta: float) -> void:
	var flares = get_tree().get_nodes_in_group("flare")
	var target = null
	var closest_distance = 10
	
	for flare in flares:
		var distance = global_position.distance_to(flare.global_position + Vector3(0,5,0))
		if distance < closest_distance:
			closest_distance = distance
			target = flare
	
	if not target and player != null:
		if global_position.distance_to(player.global_position) < 10:
			target = player
	
	if target:
		var direction = ((target.global_position + Vector3(0,-1,0)) - global_position).normalized()
		direction.y = 0
		global_position += direction * 1.2 * delta
		if animplayer and not animplayer.is_playing():
			animplayer.play("lurch")
