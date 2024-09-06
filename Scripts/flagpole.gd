extends Area2D

@onready var end = $"../CanvasLayer/End"
@onready var Player = $"../Player"
@onready var timer = $"../CanvasLayer/Timer"
@onready var next_stagebutton = $"../CanvasLayer/End/NextStage"
@onready var score = $"../CanvasLayer/End/Current score"
@onready var high_score_label = $"../CanvasLayer/End/Highscore"
@onready var one_star = $"../CanvasLayer/End/1 star header"
@onready var two_star = $"../CanvasLayer/End/2 star header"
@onready var three_star = $"../CanvasLayer/End/3 star header"
@onready var objectivecount = $"../CanvasLayer/ObjectiveCount"

signal timer_stop

var star_count = 0  # Default to 0 stars
var high_score: float = 99999.999  # Default high score
var last_seen_time: float = 0.0
var required_objects = 5  # Default required objects count

func load_game(level_number: int):
	var save_file = FileAccess.open(get_save_path(level_number), FileAccess.READ)
	if save_file:
		high_score = save_file.get_float()
		star_count = save_file.get_32()
		GlobalVariables.highest_level_unlocked = save_file.get_32()

func get_save_path(level_number: int) -> String:
	return "user://level_data_" + str(level_number) + ".save"

func save_game(level_number: int):
	var save_file = FileAccess.open(get_save_path(level_number), FileAccess.WRITE)
	save_file.store_float(high_score)
	save_file.store_32(star_count)
	save_file.store_32(GlobalVariables.highest_level_unlocked)

func _ready() -> void:
	var current_level_number = extract_level_number_from_scene_name()
	if GlobalVariables.is_level_scene():
		GlobalVariables.set_level_number(current_level_number)
		var save_file_path = get_save_path(current_level_number)
		var save_file = FileAccess.open(save_file_path, FileAccess.READ)
		if save_file:
			high_score = save_file.get_float()
			star_count = save_file.get_32()
			# We no longer update the highest_level_unlocked here
			# Instead, we only update it if the player completes the level
		else:
			save_game(current_level_number)  # Create the file with default values

		print("High Score:", high_score)
		print("Star Count:", star_count)

	update_required_objects()
	update_star_visibility()

func extract_level_number_from_scene_name() -> int:
	var current_scene = get_tree().current_scene
	if current_scene:
		var scene_path = current_scene.get_scene_file_path()
		var scene_basename = scene_path.get_file()
		var level_number_str = scene_basename.replace("Level", "").replace(".tscn", "")
		return int(level_number_str)
	return 1  # Default to level 1 if something goes wrong

func update_required_objects() -> void:
	var current_level = extract_level_number_from_scene_name()

	if current_level == 5 or current_level == 6 or current_level == 7 or current_level == 9 or current_level == 10:
		required_objects = 6
	elif current_level == 8:
		required_objects = 3
	else:
		required_objects = 5

func update_star_visibility():
	if star_count >= 3:
		three_star.visible = true
	elif star_count >= 2:
		two_star.visible = true
	elif star_count >= 1:
		one_star.visible = true

func _process(delta: float) -> void:
	objectivecount.text = str(GlobalVariables.objects) + " / " + str(required_objects)

func _on_body_entered(body: Node2D) -> void:
	update_required_objects()  # Ensure required_objects is set correctly

	# Check if the player has collected the required number of objects
	if GlobalVariables.objects == required_objects:
		end.visible = true
		next_stagebutton.grab_focus()
		GlobalVariables.speed = 0
		GlobalVariables.jump_speed = 0
		trigger_timer_stop()

		# Handle the case where last_seen_time might not be set
		var score_value: float
		if last_seen_time != 0.0:
			score_value = -last_seen_time + 32.71
		else:
			score_value = 0.0

		var formatted_score = String("%0.3f" % score_value)
		score.text = "Score : " + formatted_score  # Update the score label

		var epsilon = 0.00001

		print("Score Value:", score_value, " High Score:", high_score)

		var current_level_number = extract_level_number_from_scene_name()  # Get current level number

		if score_value < high_score - epsilon:
			print("New High Score!")
			high_score_label.text += str("%0.3f" % score_value)
			high_score = score_value
			save_game(current_level_number)  # Pass the current level number
		else:
			high_score_label.text += str("%0.3f" % high_score)
			save_game(current_level_number)  # Pass the current level number

		update_star_visibility()

		var current_run_stars = 0
		
		# Lower thresholds for levels 4, 5, 6, 7
		if current_level_number in [4, 5, 6, 7]:
			if score_value <= 15.5:  # Lowered threshold for 3 stars
				three_star.visible = true
				current_run_stars = 3
			elif score_value <= 18.0:  # Adjusted threshold for 2 stars
				two_star.visible = true
				current_run_stars = 2
			else:
				one_star.visible = true
				current_run_stars = 1
		else:  # Default star thresholds for other levels
			if score_value <= 18.5:
				three_star.visible = true
				current_run_stars = 3
			elif score_value <= 25:
				two_star.visible = true
				current_run_stars = 2
			else:
				one_star.visible = true
				current_run_stars = 1
		if current_level_number == 8:
			if score_value <= 18.2:
				three_star.visible = true
				current_run_stars = 3
			elif score_value <= 20:
				two_star.visible = true
				current_run_stars = 2
			else:
				one_star.visible = true
				current_run_stars = 1
		# Update star count and save if necessary
		if current_run_stars > star_count:
			star_count = current_run_stars
			save_game(current_level_number)  # Pass the current level number
func trigger_timer_stop() -> void:
	if timer:
		last_seen_time = timer.time_left
	else:
		last_seen_time = 0.0
	print("Emitting timer_stop signal")
	emit_signal("timer_stop")

func _on_next_stage_pressed() -> void:
	if GlobalVariables.is_level_scene():
		GlobalVariables.speed = 350
		GlobalVariables.jump_speed = -1200
		
		var current_level_number = GlobalVariables.get_level_number_int()
		var next_level_number = current_level_number + 1
		var next_level_name = "res://Scenes/Level" + str(next_level_number) + ".tscn"

		# Update highest_level_unlocked only if the player has completed this level
		if next_level_number > GlobalVariables.highest_level_unlocked:
			GlobalVariables.highest_level_unlocked = next_level_number
			GlobalVariables.save_game_data()

		if FileAccess.file_exists(next_level_name):
			GlobalVariables.set_current_scene(next_level_name)
			GlobalVariables.set_level_number(next_level_number)
			get_tree().change_scene_to_file(next_level_name)
		else:
			print("Next level does not exist. Game might be completed or there is an error.")

func _on_restart_stage_pressed() -> void:
	get_tree().reload_current_scene()
	GlobalVariables.speed = 350
	GlobalVariables.jump_speed = -1200

func _on_world_select_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/world_menu.tscn")
