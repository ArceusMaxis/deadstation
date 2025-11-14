extends RayCast3D

@export var hud_label_path: NodePath
@export var display_time: float = 4.0
@export var hover_prompt: String = " [Left Click] Collect \"%s\""
@export var final_message: String = " All set. Let's go save some people now."

var hud_label: Label
var _msg_timer: Timer
var _current_msg: String = ""
var _hovered: Node = null
var _showing_prompt: bool = false
var _timed_active: bool = false

var _collected := {
	"flashlight": false,
	"flaregun": false,
	"scanner": false
}
var _final_message_shown := false
var _pending_final_message: bool = false

func _ready() -> void:
	hud_label = get_node_or_null(hud_label_path) as Label
	_msg_timer = Timer.new()
	_msg_timer.one_shot = true
	_msg_timer.wait_time = display_time
	add_child(_msg_timer)
	_msg_timer.timeout.connect(_on_msg_timeout)
	if hud_label:
		hud_label.text = " WASD for movement, Space to Jump, Pack stuff from Van"
		hud_label.visible = true

func _physics_process(_delta: float) -> void:
	if _timed_active:
		return

	if not is_colliding():
		_clear_prompt_if_needed()
		return

	var obj := get_collider()
	if obj == null:
		_clear_prompt_if_needed()
		return

	var node := obj as Node
	if node == null:
		_clear_prompt_if_needed()
		return

	if _is_collectible(node):
		if node != _hovered:
			_hovered = node
			_show_prompt(_hover_prompt_for(node))
	else:
		_clear_prompt_if_needed()

func _input(event: InputEvent) -> void:
	if _hovered == null:
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var msg := _collect_message_for(_hovered)
		_mark_collected(_hovered)
		if is_instance_valid(_hovered):
			_hovered.queue_free()
		_hovered = null
		_show_timed(msg)
		_check_all_collected()

func _is_collectible(n: Node) -> bool:
	return n.is_in_group("flashlightintro") \
		or n.is_in_group("flaregunintro") \
		or n.is_in_group("scannerintro") \
		or n.is_in_group("collectible")

func _item_name(n: Node) -> String:
	if n.has_meta("item_name"):
		return String(n.get_meta("item_name"))
	if n.has_meta("display_name"):
		return String(n.get_meta("display_name"))
	return n.name

func _hover_prompt_for(n: Node) -> String:
	return hover_prompt % _item_name(n)

func _collect_message_for(n: Node) -> String:
	if n.is_in_group("flashlightintro"):
		return " Flashlight can be turned on/off by pressing F."
	if n.is_in_group("flaregunintro"):
		return " Equip Flaregun by pressing E."
	if n.is_in_group("scannerintro"):
		return " Equip Scanner by pressing Q."
	if n.has_meta("tutorial_text"):
		return String(n.get_meta("tutorial_text"))
	return "Collected!"

func _mark_collected(n: Node) -> void:
	if n.is_in_group("flashlightintro"):
		_collected["flashlight"] = true
	elif n.is_in_group("flaregunintro"):
		_collected["flaregun"] = true
	elif n.is_in_group("scannerintro"):
		_collected["scanner"] = true

func _check_all_collected() -> void:
	if _final_message_shown or _pending_final_message:
		return
	if _collected["flashlight"] and _collected["flaregun"] and _collected["scanner"]:
		Autoload.tutorial_complete = true
		if _timed_active:
			_pending_final_message = true
		else:
			_final_message_shown = true
			_show_timed(final_message)

func _show_prompt(text: String) -> void:
	if hud_label == null:
		return
	_msg_timer.stop()
	_timed_active = false
	_showing_prompt = true
	_current_msg = text
	hud_label.text = text
	hud_label.visible = true

func _clear_prompt_if_needed() -> void:
	if _timed_active:
		return
	if _hovered != null:
		_hovered = null
	if _showing_prompt and hud_label:
		_showing_prompt = false
		_current_msg = ""
		hud_label.text = ""
		hud_label.visible = false

func _show_timed(text: String) -> void:
	if hud_label == null:
		return
	_showing_prompt = false
	_timed_active = true
	_current_msg = text
	hud_label.text = text
	hud_label.visible = true
	_msg_timer.stop()
	_msg_timer.wait_time = display_time
	_msg_timer.start()

func _on_msg_timeout() -> void:
	_timed_active = false
	_current_msg = ""
	if hud_label:
		hud_label.text = ""
		hud_label.visible = false
	if _pending_final_message and not _final_message_shown:
		_pending_final_message = false
		_final_message_shown = true
		_show_timed(final_message)
