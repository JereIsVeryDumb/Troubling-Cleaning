extends CharacterBody2D

@export_group("Player Variables")
@export var gravity = 4000
@export_range(0.0, 1.0) var acceleration = 0.12
@export var bullet_scene = preload("res://Scenes/bullet.tscn") as PackedScene
@onready var ammo_count = $"../CanvasLayer/Ammo"
@onready var ammo_display = $"../CanvasLayer/AmmoCount"
@onready var reload_timer = $"../CanvasLayer/ReloadTimer"
@onready var reload_label = $"../CanvasLayer/ReloadTimerLabel"
@onready var mop_animator = $Mop/AnimationPlayer
@onready var interact_timer = $"../Trash1/TrashTimer"
@onready var trash_timer_label = $"../Trash1/Trash_Timer_Label"
@onready var trash_node = $"../Trash1"  # Reference to the trash node
@onready var interact_timer2 = $"../Trash2/TrashTimer"
@onready var trash_timer_label2 = $"../Trash2/Trash_Timer_Label"
@onready var trash_node2 = $"../Trash2"
@onready var interact_timer3 = $"../Trash3/TrashTimer"
@onready var trash_timer_label3 = $"../Trash3/Trash_Timer_Label"
@onready var trash_node3 = $"../Trash3"
@onready var trash_particles1 = $"../TrashParticles1"
@onready var trash_particles2 = $"../TrashParticles2"
@onready var trash_particles3 = $"../TrashParticles3"

# Preload textures for ammo display
var ammo_full_texture = preload("res://Assets/AmmoCount art full.png")
var ammo_one_missing_texture = preload("res://Assets/AmmoCount art 1 missing.png")
var ammo_two_missing_texture = preload("res://Assets/AmmoCount art 2 missing.png")
var no_ammo_texture = preload("res://Assets/No ammo.png")

var is_in_trash_area = false
var is_in_trash_area2 = false
var is_in_trash_area3 = false
var is_trash_interactive = true  # Flag to control if the trash is interactive
var is_trash_interactive2 = true
var is_trash_interactive3 = true
var can_shoot = true
var can_jump = true
@onready var bullet_spawn_sprite = $Mop/Marker2D

@onready var screensize = get_viewport_rect().size
var ammo = 3
var upndown = Input.get_axis("Lookup", "Aimdown")

func _ready():
	start()
	
	# Ensure that ammo_display is not null
	if ammo_display == null:
		print("Warning: ammo_display is null!")
	else:
		ammo_count.text = str(ammo)
	
	reload_timer.connect("timeout", Callable(self, "_on_reload_timer_timeout"))
	interact_timer.connect("timeout", Callable(self, "_on_trash_timer_timeout"))
	trash_timer_label.visible = false
	interact_timer2.connect("timeout", Callable(self, "_on_trash_timer2_timeout"))
	trash_timer_label2.visible = false
	interact_timer3.connect("timeout", Callable(self, "_on_trash_timer3_timeout"))
	trash_timer_label3.visible = false

func start():
	position = Vector2(28, 28)

enum _direction { LEFT = -1, RIGHT = 1, UP = -2, DOWN = 2 }

var current_direction: _direction = _direction.RIGHT

func _physics_process(delta):
	velocity.y += gravity * delta
	var input = Input.get_vector("Left", "Right", "Lookdown", "Lookup")
	position += input * GlobalVariables.speed * delta
	position = position.clamp(Vector2.ZERO, screensize)
	
	var dir = Input.get_axis("Left", "Right")
	position = position.clamp(Vector2(8, 8), screensize - Vector2(8, 8))
	
	if interact_timer.is_stopped() == false:
		trash_timer_label.text = '%02d' % int(ceil(interact_timer.time_left))
	if interact_timer2.is_stopped() == false:
		trash_timer_label2.text = '%02d' % int(ceil(interact_timer2.time_left))
	if interact_timer3.is_stopped() == false:
		trash_timer_label3.text = '%02d' % int(ceil(interact_timer3.time_left))
	
	if is_in_trash_area and is_trash_interactive and Input.is_action_pressed("Interact"):
		GlobalVariables.speed = 0
		GlobalVariables.jump_speed = 0
		velocity.x = 0
		interact_timer.start(5.1)
		trash_timer_label.position.x = 1
		is_trash_interactive = false
		can_shoot = false
		can_jump = false
		if current_direction == _direction.RIGHT:
			mop_animator.play("Mopping")
		elif current_direction == _direction.LEFT:
			mop_animator.play("Mopping_left")
			
	# Safely check if ammo_display is not null before assigning texture
	if ammo_display != null:
		if ammo == 3:
			ammo_display.texture = ammo_full_texture
		elif ammo == 2:
			ammo_display.texture = ammo_one_missing_texture
		elif ammo == 1:
			ammo_display.texture = ammo_two_missing_texture
		elif ammo == 0:
			ammo_display.texture = no_ammo_texture
	else:
		print("Cannot update ammo display: ammo_display is null!")
	
	if is_in_trash_area2 and is_trash_interactive2 and Input.is_action_pressed("Interact"):
		GlobalVariables.speed = 0
		GlobalVariables.jump_speed = 0
		velocity.x = 0
		interact_timer2.start(5.1)
		trash_timer_label2.position.x = 1
		is_trash_interactive2 = false
		can_jump = false
		can_shoot = false
		if current_direction == _direction.RIGHT:
			mop_animator.play("Mopping")
		elif current_direction == _direction.LEFT:
			mop_animator.play("Mopping_left")
	
	if is_in_trash_area3 and is_trash_interactive3 and Input.is_action_pressed("Interact"):
		GlobalVariables.speed = 0
		GlobalVariables.jump_speed = 0
		velocity.x = 0
		interact_timer3.start(5.1)
		trash_timer_label3.position.x = 1
		is_trash_interactive3 = false
		can_shoot = false
		can_jump = false
		if current_direction == _direction.RIGHT:
			mop_animator.play("Mopping")
		elif current_direction == _direction.LEFT:
			mop_animator.play("Mopping_left")
	
	var s = reload_timer.time_left
	reload_label.text = '%02d' % [s]

	if dir != 0:
		velocity.x = lerp(velocity.x, dir * GlobalVariables.speed, acceleration)
		$AnimationPlayer.play("Walking")
	else:
		velocity.x = lerp(velocity.x, 0.0, GlobalVariables.friction)
		$AnimationPlayer.stop()

	if dir > 0:
		$Mop.flip_h = false
		$Mop.position.x = 26
		$Sprite2D.flip_h = false
		current_direction = _direction.RIGHT
	elif dir < 0:
		$Mop.flip_h = true
		$Mop.position.x = -25
		$Sprite2D.flip_h = true
		current_direction = _direction.LEFT

	move_and_slide()

	if Input.is_action_just_pressed("Jump") and is_on_floor() and can_jump == true:
		velocity.y = GlobalVariables.jump_speed
		$JumpSound.play()

	if Input.is_action_just_pressed("Shoot") and ammo > 0 and can_shoot == true:
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
	GlobalVariables.speed = 350
	GlobalVariables.jump_speed = -1200
	interact_timer.stop()
	mop_animator.stop()
	is_trash_interactive = false  
	trash_node.visible = false
	can_shoot = true
	can_jump = true
	GlobalVariables.objects += 1
	trash_particles1.emitting = true
	trash_particles1.visible = true

func _on_trash_timer2_timeout() -> void:
	GlobalVariables.speed = 350
	GlobalVariables.jump_speed = -1200
	interact_timer2.stop()
	mop_animator.stop()
	is_trash_interactive2 = false
	trash_node2.visible = false
	trash_particles2.emitting = true
	trash_particles2.visible = true
	can_shoot = true
	can_jump = true
	GlobalVariables.objects += 1
	
func _on_trash2_body_entered(body: Node2D) -> void:
	is_in_trash_area2 = true
	trash_timer_label2.visible = true
	print("jesus")

func _on_trash2_body_exited(body: Node2D) -> void:
	is_in_trash_area2 = false
	mop_animator.stop()
	trash_timer_label2.visible = false

func _on_trash_timer3_timeout() -> void:
	GlobalVariables.speed = 350
	GlobalVariables.jump_speed = -1200
	interact_timer3.stop()
	mop_animator.stop()
	is_trash_interactive3 = false  
	trash_node3.visible = false
	can_shoot = true
	can_jump = true
	GlobalVariables.objects += 1
	trash_particles3.emitting = true
	trash_particles3.visible = true
func _on_trash3_body_entered(body: Node2D) -> void:
	is_in_trash_area3 = true
	trash_timer_label3.visible = true


func _on_trash3_body_exited(body: Node2D) -> void:
	is_in_trash_area3 = false
	mop_animator.stop()
	trash_timer_label3.visible = false
