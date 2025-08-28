extends CharacterBody2D

class_name Bird

signal game_started

@export var gravity = 3600.0
@export var jump_force = -1200
@export var rotation_speed = 2
@onready var bird_1 = $Gummy
@onready var animation_player = $AnimationPlayer
@onready var flapsound: AudioStreamPlayer = $flapsound
@onready var crashsound: AudioStreamPlayer = $crashsound
@onready var menumusic: AudioStreamPlayer = $menumusic
@onready var moon: Label = $"../UI/moon"
@onready var moon_button: Button = $"../UI/Moon Button"

var max_speed = 1600
var is_started = false
var should_process_input = true

func _ready():
	velocity = Vector2.ZERO
	animation_player.play("idle")
	menumusic.play()
	
func _physics_process(delta):
	if Input.is_action_just_pressed("jump") and should_process_input:
		if not is_started:
			game_started.emit()
			animation_player.play("flap_wings")
			is_started = true
			menumusic.stop()
		jump()

	if not is_started:
		return

	velocity.y += gravity * delta
	velocity.y = min(velocity.y, max_speed)

	move_and_collide(velocity * delta)
	rotate_bird()

func jump():
	velocity.y = jump_force
	rotation = deg_to_rad(-30)
	flapsound.play()

func rotate_bird():
	if velocity.y > 0 and rad_to_deg(rotation) < 90:
		rotation += rotation_speed * deg_to_rad(1)
	elif velocity.y < 0 and rad_to_deg(rotation) > -30:
		rotation -= rotation_speed * deg_to_rad(1)

func kill():
	should_process_input = false

func stop():
	animation_player.stop()
	gravity = 0
	velocity = Vector2.ZERO
	should_process_input = false
	crashsound.play()

func _on_moon_button_pressed():
	gravity = 450
	jump_force = -300
	moon.visible = false
	moon_button.visible = false
