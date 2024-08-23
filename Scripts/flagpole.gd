extends Area2D

@onready var current_scene = get_tree().current_scene.name
@onready var end = $"../CanvasLayer/End"
@onready var timer = $CanvasLayer/Timer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if GlobalVariables.objects == 1:
		end.visible = true
		
