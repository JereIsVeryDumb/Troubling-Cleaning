extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HBoxContainer/Playbutton.grab_focus()
	GlobalVariables.speed = 350
	if GlobalVariables.has_seen_tutorial == false:
		get_tree().change_scene_to_file("res://Scenes/tutorial_screen.tscn")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $Options_Menu.visible == true:
		$HBoxContainer/Settingsbutton.disabled = true
		$HBoxContainer/Playbutton.disabled = true
		$HBoxContainer/Quit.disabled = true
		$TutorialButton.disabled = true
	else:
		$HBoxContainer/Settingsbutton.disabled = false
		$HBoxContainer/Playbutton.disabled = false
		$HBoxContainer/Quit.disabled = false
		$TutorialButton.disabled = false
func _on_button_pressed() -> void:

	get_tree().change_scene_to_file("res://Scenes/world_menu.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_tutorial_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/tutorial_screen.tscn")


func _on_settingsbutton_pressed() -> void:
	$Options_Menu.visible = true
