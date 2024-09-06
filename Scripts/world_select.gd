extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_level_buttons()

func update_level_buttons() -> void:
	var highest_level_unlocked = GlobalVariables.highest_level_unlocked
	
	for i in range(1, 11):
		var button_name = "Level" + str(i) + "Button"
		var button = get_node_or_null(button_name)
		var star_label_name = button_name + "/Level" + str(i) + "StarCount"
		var star_label = get_node_or_null(star_label_name)
		
		if button:
			# Disable buttons for levels that haven't been unlocked yet
			button.disabled = i > highest_level_unlocked
			
			# Fetch the star count for this level from saved data
			var star_count = get_star_count(i)
			
			# Update the star count label if it exists and is of type Label
			if star_label and star_label is Label:
				# Show label for unlocked levels, hide for locked ones
				star_label.text = str(star_count) + "☆/3☆"
				star_label.visible = i <= highest_level_unlocked
				
	# Set focus to the highest unlocked level button
	if highest_level_unlocked > 0:
		var highest_button_name = "Level" + str(highest_level_unlocked) + "Button"
		var highest_button = get_node_or_null(highest_button_name)
		if highest_button:
			highest_button.grab_focus()

# Function to retrieve the star count for a level
func get_star_count(level_number: int) -> int:
	var save_file_path = "user://level_data_" + str(level_number) + ".save"
	var save_file = FileAccess.open(save_file_path, FileAccess.READ)
	if save_file:
		save_file.get_float()  # Skip high score
		return save_file.get_32()  # Star count
	return 0  # Return 0 if no save data is found

# Button press handlers for each level
func _on_level_button_pressed(level_number: int) -> void:
	# Ensure that the player can only access unlocked levels
	if level_number <= GlobalVariables.highest_level_unlocked:
		var scene_path = "res://Scenes/Level" + str(level_number) + ".tscn"
		if FileAccess.file_exists(scene_path):
			GlobalVariables.set_current_scene(scene_path)
			GlobalVariables.set_level_number(level_number)
			get_tree().change_scene_to_file(scene_path)
		else:
			print("Scene does not exist.")
	else:
		print("This level is locked.")

# Connect each button to this handler, passing the appropriate level number
func _on_level_1_button_pressed() -> void: _on_level_button_pressed(1)
func _on_level_2_button_pressed() -> void: _on_level_button_pressed(2)
func _on_level_3_button_pressed() -> void: _on_level_button_pressed(3)
func _on_level_4_button_pressed() -> void: _on_level_button_pressed(4)
func _on_level_5_button_pressed() -> void: _on_level_button_pressed(5)
func _on_level_6_button_pressed() -> void: _on_level_button_pressed(6)
func _on_level_7_button_pressed() -> void: _on_level_button_pressed(7)
func _on_level_8_button_pressed() -> void: _on_level_button_pressed(8)
func _on_level_9_button_pressed() -> void: _on_level_button_pressed(9)
func _on_level_10_button_pressed() -> void: _on_level_button_pressed(10)


func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
