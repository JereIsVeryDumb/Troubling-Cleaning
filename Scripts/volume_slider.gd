extends HSlider
@export

var bus_name : String
var bus_index : int 
var step_size: float = 0.05  # Set a step size (adjust as needed)

func _ready() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)
	
	# Load the saved volume value from GlobalVariables
	value = GlobalVariables.volume_value
	
	# Set the AudioServer bus volume based on the saved value
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	
	# Set the step size for keyboard input
	step = step_size  
	
	# Connect the signal to handle changes in the slider value
	value_changed.connect(_on_value_changed)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_value_changed(value: float) -> void:
	GlobalVariables.volume_value = value  # Update the global volume variable
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	GlobalVariables.save_game_data()
