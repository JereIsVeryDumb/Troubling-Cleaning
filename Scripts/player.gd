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
@onready var mop_animator = $Mop/AnimationPlayer
@onready var interact_timer = $"../Trash/TrashTimer"
@onready var trash_timer_label = $"../Trash/Trash_Timer_Label"
@onready var trash_node = $"../Trash"  # Reference to the trash node

var is_in_trash_area = false
var is_trash_interactive = true  # Flag to control if the trash is interactive

@onready var bullet_spawn_sprite = $Mop/Marker2D

@onready var screensize = get_viewport_rect().size
var ammo = 3
var upndown = Input.get_axis("Lookup", "Aimdown")

func _ready():
	start()
	ammo_count.text = str(ammo)
	reload_timer.connect("timeout", Callable(self, "_on_reload_timer_timeout"))
	interact_timer.connect("timeout", Callable(self, "_on_trash_timer_timeout"))
	trash_timer_label.visible = false
func start():
	position = Vector2(28,28)

enum _direction { LEFT = -1, RIGHT = 1, UP = -2, DOWN = 2 }

var current_direction: _direction = _direction.RIGHT

func _physics_process(delta):
	velocity.y += gravity * delta
	var input = Input.get_vector("Left", "Right", "Lookdown", "Lookup")
	position += input * speed * delta
	position = position.clamp(Vector2.ZERO, screensize)
	
	var dir = Input.get_axis("Left", "Right")
	position = position.clamp(Vector2(8, 8), screensize - Vector2(8, 8))
	
	if interact_timer.is_stopped() == false:
		trash_timer_label.text = '%02d' % int(ceil(interact_timer.time_left))
	
	if is_in_trash_area and is_trash_interactive and Input.is_action_pressed("Interact"):
		speed = 0
		jump_speed = 0
		interact_timer.start(5.1)
		trash_timer_label.position.x = 1
		if current_direction == _direction.RIGHT:
			mop_animator.play("Mopping")
		elif current_direction == _direction.LEFT:
			mop_animator.play("Mopping_left")
	
	var s = reload_timer.time_left
	reload_label.text = '%02d' % [s]

	if dir != 0:
		velocity.x = lerp(velocity.x, dir * speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0.0, friction)

	if dir > 0:
		$Mop.flip_h = false
		$Mop.position.x = 10
		$Sprite2D.flip_h = false
		current_direction = _direction.RIGHT
	elif dir < 0:
		$Mop.flip_h = true
		$Mop.position.x = -10
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
	
	if current_direction == _direction.RIGHT:
		mop_animator.play("Flick")
	
	if current_direction == _direction.LEFT:
		mop_animator.play("Flick_left")
	
	if ammo >= 0:
		ammo_count.text = str(ammo)
	
	if Input.is_action_pressed("AimUp"):
		bullet_direction = Vector2(0, -1)
		mop_animator.play("Flick_up")
	elif Input.is_action_pressed("Aimdown"):
		mop_animator.play("Flick_down")
		bullet_direction = Vector2(0, 1)
	else:
		bullet_direction = Vector2(current_direction, 0)

	# Use the bullet_spawn_sprite's position
	b.start(bullet_spawn_sprite.global_position, bullet_direction)

func _on_hottub_body_entered(body):
	if reload_timer.time_left < 1 and ammo < 3:
		ammo = 3
		ammo_count.text = str(ammo)
		if reload_timer.time_left == 0:
			reload_timer.set_wait_time(10)
			reload_timer.start()

func _on_reload_timer_timeout():
	print("Timer timed out!")

func _on_trash_body_entered(body):
	is_in_trash_area = true
	trash_timer_label.visible = true

func _on_trash_body_exited(body: Node2D) -> void:
	is_in_trash_area = false
	mop_animator.stop()
	trash_timer_label.visible = false

func _on_trash_timer_timeout() -> void:
	speed = 350
	jump_speed = -1200
	interact_timer.stop()
	mop_animator.stop()
	is_trash_interactive = false  
	trash_node.visible = false
	GlobalVariables.objects += 1
