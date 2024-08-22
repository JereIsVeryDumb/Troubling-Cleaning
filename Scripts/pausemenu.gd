extends VBoxContainer
var _is_paused:bool = false:
	set = set_paused
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Pause"):
		_is_paused = !_is_paused

func set_paused(value:bool) -> void:
	_is_paused = value
	get_tree().paused = _is_paused
	visible = _is_paused

# Called every frame. 'delta' is the elapsed time since the previous frame.



func _on_resume_pressed() -> void:
	_is_paused = false


func _on_restart_pressed() -> void:
	_is_paused = false
	get_tree().reload_current_scene()
	print("jesus")


func _on_settings_pressed() -> void:
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	_is_paused = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
