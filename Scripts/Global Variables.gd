extends Node

# Declare a dictionary or another structure to track objects
var objects = 0
var object_counters = {}
var speed = 350
var jump_speed = -1200
@onready var current_level = "res://Scenes/Level1.tscn"


var save_data:SaveData


# Initialize the object in the global tracker
func track_object(object_id):
	if not object_counters.has(object_id):
		object_counters[object_id] = false

func _ready() -> void:
	save_data = SaveData.load_or_create()
