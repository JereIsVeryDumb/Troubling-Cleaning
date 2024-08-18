extends Node

# Declare a dictionary or another structure to track objects
var objects = 0
var object_counters = {}

# Initialize the object in the global tracker
func track_object(object_id):
	if not object_counters.has(object_id):
		object_counters[object_id] = false
