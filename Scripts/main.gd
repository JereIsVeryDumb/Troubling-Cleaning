extends Node2D

@onready var timer = $CanvasLayer/Timer
@onready var total_time_seconds : float = 0.0
@onready var label = $CanvasLayer/Label
@onready var objectivecount = $CanvasLayer/ObjectiveCount
@onready var flagpole = $Flagpole

func _ready() -> void:
	GlobalVariables.load_game_data()
	timer.start()
	if flagpole:
		print("Connecting to Flagpole's timer_stop signal")
		var connection_result = flagpole.connect("timer_stop", Callable(self, "_on_timer_stop"))
		print("Connection result:", connection_result)
	else:
		print("Flagpole node not found!")


func _process(delta: float) -> void:
	if not timer.is_stopped():
		total_time_seconds += delta
		var m = int(total_time_seconds / 60)
		var s = int(total_time_seconds) % 60
		var ms = int((total_time_seconds - int(total_time_seconds)) * 1000)
		label.text = '%02d:%02d:%03d' % [m, s, ms]
func _on_timer_stop() -> void:
	print("Timer stop signal received")
	if not timer.is_stopped():
		timer.stop()
		print("Timer stopped")
	else:
		print("Timer was already stopped")
