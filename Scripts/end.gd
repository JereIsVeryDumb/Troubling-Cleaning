extends Control
@onready var restart_stage = $RestartStage
@onready var next_stage = $NextStage
@onready var world_select = $WorldSelect
@onready var score = $"Current score"
@onready var high_score = $Highscore
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
