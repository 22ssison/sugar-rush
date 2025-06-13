extends Node

class_name PipeSpawner

signal bird_crashed
signal point_scored


var pipe_pair_scene = preload("res://Scenes/pipe_pair.tscn")


@export var pipe_speed = -150 
@onready var timer = $"../Timer"
@onready var spawn_timer: Timer = $SpawnTimer

func _ready():
	spawn_timer.start()
	
func start_spawning_pipes():
	spawn_timer.timeout.connect(spawn_pipe)
	
func spawn_pipe():
	var pipe = pipe_pair_scene.instantiate() as PipePair
	add_child(pipe)
	
	var viewport_rect = get_viewport().get_camera_2d().get_viewport_rect()
	pipe.position.x = viewport_rect.end.x

	
	var half_height = viewport_rect.size.y / 2
	pipe.position.y = randf_range(viewport_rect.size.y * 0.15 - half_height, viewport_rect.size.y * 0.65 - half_height)
	
	pipe.bird_entered.connect(on_bird_entered)
	pipe.point_scored.connect(on_point_scored)
	pipe.set_speed(pipe_speed)
	
	
func on_bird_entered():
	bird_crashed.emit()
	stop()

func stop():
	spawn_timer.stop()
	for pipe in get_children().filter(func (child): return child is PipePair):
		(pipe as PipePair).speed = 0 # this won't be called for a spawner bc we're getting all of the children and then filtering any that are not pipe pairs.
	
func on_point_scored():
	point_scored.emit()
 
func _on_speed_button_pressed() -> void:
	pipe_speed = -300 # if you change the pipe speed, but not the ground speed, this is great when you want to change the scene after a certain point. Its very cool. 
		
	#	add a variable how many pipes spawn at a time. however, you need to setup to make sure that works
