extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HBoxContainer/Playbutton.grab_focus()
	GlobalVariables.speed = 350

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
 # Ensure the level number is at least 1
	var level_number = max(GlobalVariables.highest_level_unlocked, 1)
	var level_path = "res://Scenes/Level" + str(level_number) + ".tscn"
	
	if FileAccess.file_exists(level_path):
		get_tree().change_scene_to_file(level_path)
	else:
		print("Level path does not exist:", level_path)


func _on_quit_pressed() -> void:
	get_tree().quit()
