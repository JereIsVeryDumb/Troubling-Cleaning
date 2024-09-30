extends VBoxContainer

var _is_paused: bool = false

func _ready() -> void:
	# Ensure the focus is set correctly on a control that can receive keyboard input
	$Resume.grab_focus()  # Change this if your actual button node is different

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Pause"):
		_is_paused = !_is_paused
		update_pause_state()

func update_pause_state() -> void:
	get_tree().paused = _is_paused
	visible = _is_paused
	if _is_paused:
		# Ensure the focus is set on the correct control
		$Resume.grab_focus()

func _on_resume_pressed() -> void:
	_is_paused = false
	update_pause_state()

func _on_restart_pressed() -> void:
	_is_paused = false
	update_pause_state()
	get_tree().reload_current_scene()
	print("Restarting scene")
	GlobalVariables.speed = 350
	GlobalVariables.jump_speed = -1200

func _on_settings_pressed() -> void:
	$"../Options_Menu".visible = true

func _on_quit_pressed() -> void:
	_is_paused = false
	update_pause_state()
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
