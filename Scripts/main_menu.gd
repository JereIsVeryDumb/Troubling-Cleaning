extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HBoxContainer/Playbutton.grab_focus()
	GlobalVariables.speed = 350

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_pressed() -> void:

	get_tree().change_scene_to_file("res://Scenes/world_menu.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
