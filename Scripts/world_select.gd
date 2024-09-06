extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_level_buttons()

func update_level_buttons() -> void:
	var highest_level_unlocked = GlobalVariables.highest_level_unlocked
	
	for i in range(1, 11):
		var button_name = "Level" + str(i) + "Button"
		var button = get_node(button_name)
		
		if button:
			button.disabled = i > highest_level_unlocked

	# Set focus to the highest level unlocked button
	if highest_level_unlocked > 0:
		var highest_button_name = "Level" + str(highest_level_unlocked) + "Button"
		var highest_button = get_node(highest_button_name)
		if highest_button:
			highest_button.grab_focus()

func _on_level_1_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Level1.tscn")

func _on_level_2_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Level2.tscn")

func _on_level_3_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Level3.tscn")

func _on_level_4_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Level4.tscn")

func _on_level_5_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Level5.tscn")

func _on_level_6_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Level6.tscn")

func _on_level_7_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Level7.tscn")

func _on_level_8_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Level8.tscn")

func _on_level_9_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Level9.tscn")

func _on_level_10_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Level10.tscn")
