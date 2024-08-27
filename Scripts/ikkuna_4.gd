extends Node2D

@onready var animator = $AnimatedSprite2D
var can_becleaned = true
var object_id = "Ikkuna4"

func _ready():
	GlobalVariables.objects = 0
	can_becleaned = true

	if GlobalVariables.object_counters.has(object_id):
		GlobalVariables.object_counters.erase(object_id)

	GlobalVariables.track_object(object_id)

func _process(delta):
	pass

func _on_area_2d_area_entered(area):
	if can_becleaned and not GlobalVariables.object_counters[object_id]:
		animator.play("default")
		can_becleaned = false
		GlobalVariables.objects += 1
		GlobalVariables.object_counters[object_id] = true
		print(GlobalVariables.objects)
