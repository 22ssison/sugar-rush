extends Node2D

class_name Ground

signal bird_crashed # signal to other nodes that something had changed/happend.
signal point_scored

@export var speed = -150

@onready var sprite1 = $Ground1/Sprite2D
@onready var sprite2 = $Ground2/Sprite2D


func _ready():
	sprite2.global_position.x = sprite1.global_position.x + sprite1.texture.get_width()
	
func _process(delta): # movement of the ground passing by
	sprite1.global_position.x += speed * delta
	sprite2.global_position.x += speed * delta

	# if sprite1 has completely left the screen move it to the right of sprite2
	if sprite1.global_position.x < -sprite1.texture.get_width(): # if the sprite already moved to the whole width of its texture, then, reaply the sprite position to be the starting position of sprite 2 
		sprite1.global_position.x = sprite2.global_position.x + sprite2.texture.get_width()
		# if sprite2 has completely left the screen move it to the right of sprite1
		# should give us the notion of just endless scrolling
	if sprite2.global_position.x < -sprite2.texture.get_width():
		sprite2.global_position.x = sprite1.global_position.x + sprite1.texture.get_width()

func on_point_scored(body):
	speed += 30 # speeds up the gamepley of the pipes. Note: make sure to also change the speed of the ground and the pipes spawning.
	point_scored.emit()

func _on_body_entered(body): # ground1 & 2 connected to this function here.
	bird_crashed.emit()
	stop()
	(body as Bird).stop()
	
func stop():
	speed = 0


func _on_button_2_pressed() -> void:
	speed = -300
