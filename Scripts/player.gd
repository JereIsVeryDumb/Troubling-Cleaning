extends CharacterBody2D

@export_group("Player Variables")
@export var speed = 350
@export var jump_speed = -1200
@export var gravity = 4000
@export_range(0.0, 1.0) var friction = 0.2
@export_range(0.0, 1.0) var acceleration = 0.25
@export var bullet_scene = preload("res://Scenes/bullet.tscn") as PackedScene
@onready var ammo_count = $"../CanvasLayer/Ammo"
@onready var reload_timer = $"../CanvasLayer/ReloadTimer"
@onready var reload_label = $"../CanvasLayer/ReloadTimerLabel"

@onready var screensize = get_viewport_rect().size
var ammo = 3
var upndown = Input.get_axis("Lookup", "Aimdown")

func _ready():
	start()
	ammo_count.text = str(ammo)
	reload_timer.connect("timeout", Callable(self, "_on_reload_timer_timeout"))

func start():
	position = Vector2(screensize.x / 2, screensize.y - 64)

enum _direction { LEFT = -1, RIGHT = 1, UP = -2, DOWN = 2 }

var current_direction: _direction = _direction.RIGHT

func _physics_process(delta):
	velocity.y += gravity * delta
	var input = Input.get_vector("Left", "Right", "Lookdown", "Lookup")
	position += input * speed * delta
	position = position.clamp(Vector2.ZERO, screensize)
	
	var dir = Input.get_axis("Left", "Right")
	position = position.clamp(Vector2(8, 8), screensize - Vector2(8, 8))
	
	
	var s = reload_timer.time_left
	
	reload_label.text = '%02d' % [s]
	if dir != 0:
		velocity.x = lerp(velocity.x, dir * speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0.0, friction)

	if dir > 0:
		$Sprite2D.flip_h = false
		current_direction = _direction.RIGHT
	elif dir < 0:
		$Sprite2D.flip_h = true
		current_direction = _direction.LEFT

	move_and_slide()

	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = jump_speed

	if Input.is_action_just_pressed("Shoot") and ammo > 0:
		shoot()
	
func shoot():
	var b = bullet_scene.instantiate() as Area2D
	get_tree().root.add_child(b)
	
	var bullet_direction = Vector2()
	ammo -= 1
	
	if ammo >= 0:
		ammo_count.text = str(ammo)
	
	if Input.is_action_pressed("AimUp"):
		bullet_direction = Vector2(0, -1)
	elif Input.is_action_pressed("Aimdown"):
		bullet_direction = Vector2(0, 1)
	else:
		bullet_direction = Vector2(current_direction, 0)

	b.start(position, bullet_direction)

func _on_hottub_body_entered(body):
	if reload_timer.time_left < 1 and ammo < 3:
		ammo = 3
		ammo_count.text = str(ammo)
		if reload_timer.time_left == 0:
			reload_timer.set_wait_time(10)
			reload_timer.start()
func _on_reload_timer_timeout():
	print("Timer timed out!")
