extends Area2D


@onready var Level2 = preload("res://Scenes/level_2.tscn") as PackedScene
@onready var current_scene = get_tree().current_scene.name


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	var current_scene = get_tree().current_scene.name
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if current_scene == "Level1" and GlobalVariables.objects == 5:
		get_tree().change_scene_to_file("res://Scenes/level_2.tscn")
