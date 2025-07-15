extends Node2D

class_name Ground

signal bird_crashed
signal point_scored

@export var speed = -600

@onready var sprite1 = $Ground1/Sprite2D
@onready var sprite2 = $Ground2/Sprite2D

func _ready():
	sprite2.global_position.x = sprite1.global_position.x + sprite1.texture.get_width()

func _process(delta):
	sprite1.global_position.x += speed * delta
	sprite2.global_position.x += speed * delta

	if sprite1.global_position.x < -sprite1.texture.get_width():
		sprite1.global_position.x = sprite2.global_position.x + sprite2.texture.get_width()

	if sprite2.global_position.x < -sprite2.texture.get_width():
		sprite2.global_position.x = sprite1.global_position.x + sprite1.texture.get_width()

func on_point_scored(body):
	speed += 15
	point_scored.emit()

func _on_body_entered(body):
	bird_crashed.emit()
	stop()
	(body as Bird).stop()

func stop():
	speed = 0

func _on_button_2_pressed():
	speed = -300
