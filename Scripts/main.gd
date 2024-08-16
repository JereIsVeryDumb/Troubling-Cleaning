extends Node2D

@onready var timer = $CanvasLayer/Timer
@onready var total_time_seconds : float = 0.0
@onready var label = $CanvasLayer/Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	total_time_seconds += delta
	var m = int(total_time_seconds / 60)
	var s = int(total_time_seconds) % 60
	var ms = int((total_time_seconds - int(total_time_seconds)) * 1000)
	label.text = '%02d:%02d:%03d' % [m, s, ms]
