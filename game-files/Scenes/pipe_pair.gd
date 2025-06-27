extends Node2D

class_name PipePair
signal  bird_entered
signal point_scored

var speed = 0

func set_speed(new_speed):
	speed = new_speed
	
func _process(delta):
	position.x += speed * delta
	
func _on_body_entered(body):
	bird_entered.emit()
	
func on_point_scored(body):
	speed += 35 # speeds up the gamepley of the pipes. Note: make sure to also change the speed of the ground and the pipes spawning.
	point_scored.emit()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
