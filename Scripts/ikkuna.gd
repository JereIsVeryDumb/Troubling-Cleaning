extends Node2D
@onready var animator =  $AnimatedSprite2D
var can_becleaned = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass





func _on_area_2d_area_entered(area):
	if can_becleaned == true:
		animator.play("default")
		can_becleaned = false
		GlobalVariables.objects += 1
		print(GlobalVariables.objects)
