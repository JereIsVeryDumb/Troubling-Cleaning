extends Area2D

@onready var end = $"../CanvasLayer/End"
@onready var Player = $"../Player"
@onready var timer = $"../CanvasLayer/Timer"
@onready var next_stagebutton = $"../CanvasLayer/End/NextStage"
@onready var score = $"../CanvasLayer/End/Current score"
@onready var high_score = $"../CanvasLayer/End/Highscore"
signal timer_stop

var last_seen_time: float = 0.0

func _ready() -> void:
	var high_score:int = GlobalVariables.save_data.high_score

func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if GlobalVariables.objects == 0:
		end.visible = true
		next_stagebutton.grab_focus()
		GlobalVariables.speed = 0
		GlobalVariables.jump_speed = 0
		trigger_timer_stop()
		var score_value = -last_seen_time + 6500
		var formatted_score = String("%0.3f" % score_value)
		score.text = "Score : " + formatted_score  # Update the score label



func trigger_timer_stop() -> void:
	last_seen_time = timer.time_left  # Capture the timer's last seen value
	print("Emitting timer_stop signal")
	emit_signal("timer_stop")

func _on_next_stage_pressed() -> void:
	pass


func _on_restart_stage_pressed() -> void:
	get_tree().reload_current_scene()
	GlobalVariables.speed = 350
	GlobalVariables.jump_speed = -1200

func _on_world_select_pressed() -> void:
	pass
