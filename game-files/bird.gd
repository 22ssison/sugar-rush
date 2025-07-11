extends CharacterBody2D

class_name Bird

signal game_started

@export var gravity = 3600.0 # can change this
@export var jump_force = -1200 # multiply everything by 4 from the initial.
@export var rotation_speed = 2

@onready var animation_player = $AnimationPlayer
var max_speed = 1600
var  is_started = false # when it starts it should apply the gravity but if not,  it should not apply the gravity.
var should_process_input = true #by default yes input by user

func _ready():
	velocity = Vector2.ZERO #describing how our character is moving, in this case: its not going to move.
	animation_player.play("idle")
	
func _physics_process(delta):
	if Input.is_action_just_pressed("jump") && should_process_input:
		if !is_started: 
			game_started.emit()
			animation_player.play("flap_wings")
			is_started =  true 
		jump()
	
	  
	if !is_started: #if not is_started 
		return
	velocity.y += gravity * delta
	
	velocity.y = min(velocity.y, max_speed)
	
	move_and_collide(velocity * delta)
	
	rotate_bird()
  
func jump():
	velocity.y = jump_force
	rotation = deg_to_rad(-30) 
	
	
func rotate_bird():
	#rotate downwards when falling
	if velocity.y > 0 && rad_to_deg(rotation) < 90:
		rotation += rotation_speed * deg_to_rad(1)
	# Rotate upwaards when rising
	elif velocity.y < 0 && rad_to_deg(rotation) > -30:
		rotation -= rotation_speed * deg_to_rad(1)

func kill():
	should_process_input = false

func stop():
	animation_player.stop() # makes everything just stop - placeholder, alter this in sprint 2
	gravity = 0 # do not continue movement down
	velocity = Vector2.ZERO
	should_process_input = false # if not, then the bird stop.


func _on_moon_button_pressed() -> void:
	gravity = 450
	jump_force = -300
