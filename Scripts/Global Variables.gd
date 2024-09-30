extends Node

# Declare global variables to track game state
var objects = 0
var object_counters = {}
var speed = 350
var jump_speed = -1200
var current_level: String = "res://Scenes/Level1.tscn"
var friction = 0.265
var highest_level_unlocked: int = 1
var level_number: int = 1  # Add this to store the current level number
var is_music_playing = false
var current_scene_path: String = ""
var has_seen_tutorial = false
var volume_value: float = 1.0 
# Path for the save file
const SAVE_PATH = "user://game_save_data.save"

func _ready() -> void:
	current_scene_path = ""
	load_game_data() 

func update_current_scene_path() -> void:
	var scene = get_tree().current_scene
	if scene and scene.filename:
		current_scene_path = scene.filename
	else:
		current_scene_path = ""

func set_current_scene(path: String) -> void:
	current_level = path

func get_current_scene_path() -> String:
	return current_level

func is_level_scene() -> bool:
	return current_level.begins_with("res://Scenes/Level")

func get_level_number() -> String:
	return current_level.get_file().replace("Level", "").replace(".tscn", "")

# New function to set the current level number
func set_level_number(level: int) -> void:
	level_number = level

# Function to get the current level number
func get_level_number_int() -> int:
	return level_number

# Initialize the object in the global tracker
func track_object(object_id):
	if not object_counters.has(object_id):
		object_counters[object_id] = false

func save_game_data() -> void:
	var save_file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if save_file:
		# Save other data (e.g., highest level unlocked, etc.)
		save_file.store_32(highest_level_unlocked)
		
		# Save volume value
		save_file.store_line(str(volume_value))  # Convert float to string before saving
		
		# Save other data, such as seen tutorial status
		save_file.store_line(str(has_seen_tutorial))
		save_file.close()

func load_game_data() -> void:
	var save_file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if save_file:
		highest_level_unlocked = save_file.get_32()
		
		# Load volume value (if present)
		if not save_file.eof_reached():
			volume_value = save_file.get_line().to_float()  # Convert string back to float
		
		# Load other data
		if not save_file.eof_reached():
			var seen_tutorial_str = save_file.get_line().strip_edges()
			has_seen_tutorial = (seen_tutorial_str == "true")
		
		save_file.close()
	else:
		print("Save file not found. Starting with default values.")
		# Set default values if no save file exists
		volume_value = 1.0
		has_seen_tutorial = false
