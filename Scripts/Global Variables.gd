extends Node

# Declare a dictionary or another structure to track objects
var objects = 0
var object_counters = {}
var speed = 350
var jump_speed = -1200
var current_level: String = "res://Scenes/Level1.tscn"
var friction = 0.265

var highest_level_unlocked: int = 1

var current_scene_path: String = ""

func _ready() -> void:
	# Set the initial scene path to an empty string or default value
	current_scene_path = ""

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
	# Ensure that the current_level path starts with "res://Scenes/Level"
	return current_level.begins_with("res://Scenes/Level")
# Example of a function that might need updating
func on_scene_changed():
	update_current_scene_path()
	if is_level_scene():
		print("Current scene is a level:", current_scene_path)
	else:
		print("Current scene is not a level.")


func get_level_number() -> String:
	return current_level.get_file().replace("Level", "").replace(".tscn", "")


# Initialize the object in the global tracker
func track_object(object_id):
	if not object_counters.has(object_id):
		object_counters[object_id] = false
