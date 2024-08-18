extends Area2D

var speed = 560
var direction = Vector2(1, 0)  # Default direction

func start(pos: Vector2, dir: Vector2):
	position = pos
	direction = dir.normalized()  # Normalize direction to ensure it's a unit vector

	# Rotate the bullet based on the direction
	if direction == Vector2(0, -1):  # Up
		rotation_degrees = -90
	elif direction == Vector2(0, 1):  # Down
		rotation_degrees = 90
	elif direction == Vector2(-1, 0):  # Left
		rotation_degrees = 180
	else:  # Right or any other direction
		rotation_degrees = 0

func _physics_process(delta):
	# Update the position based on direction and speed
	position += direction * speed * delta
	

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()




func _on_body_entered(body):
	queue_free()
