extends Area2D

var direction := 1  # 1 for right, -1 for left
var speed := 100  # Speed of movement

func _ready() -> void:
	# Initialize if needed
	pass

func _process(delta: float) -> void:
	# Move the platform in the current direction
	position.x += direction * speed * delta
	
	# Get the screen size
	var screen_size := get_viewport_rect().size
	
	# Get the platform's width
	var platform_width := 0.0
	
	# If the platform has a Sprite child node
	if has_node("Sprite"):
		platform_width = get_node("Sprite").texture.get_size().x
	# If the platform has a CollisionShape2D child node
	elif has_node("CollisionShape2D"):
		var shape = get_node("CollisionShape2D").shape
		if shape is RectangleShape2D:
			platform_width = shape.extents.x * 2  # RectangleShape2D stores half-extents
	
	# Check if the platform has reached the left or right edge
	if position.x <= 0:
		direction = 1  # Start moving right
	elif position.x + platform_width >= screen_size.x:
		direction = -1  # Start moving left
