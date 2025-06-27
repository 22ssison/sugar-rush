extends Node

class_name PipeSpawner

signal bird_crashed
signal point_scored


var pipe_pair_scene = preload("res://Scenes/pipe_pair.tscn")

@onready var background_1 = $"../Background 1"
@onready var background_2 = $"../Background 2"
@onready var background_3 = $"../Background 3"
@onready var background_4 = $"../Background 4"

@export var pipe_speed = -500
@onready var timer = $"../Timer"
@onready var spawn_timer: Timer = $SpawnTimer
var hidden_points =  0
func _ready():
	spawn_timer.start()
	randomize()

func start_spawning_pipes():
	spawn_timer.timeout.connect(spawn_pipe)
	
func spawn_pipe():
	var pipe = pipe_pair_scene.instantiate() as PipePair
	add_child(pipe)
	
# Get the Camera2D position in world space
	var camera = get_viewport().get_camera_2d()
	if camera == null:
		print("Camera2D not found!")
		return

	var viewport_size = get_viewport().get_visible_rect().size
	
	# Pipe X = Camera center X + half screen width + buffer (spawns just off right edge)
	pipe.position.x = camera.global_position.x + (viewport_size.x / 2) + 100

	# Pipe Y = Random within safe vertical range, relative to Camera center Y
	var min_y = camera.global_position.y - (viewport_size.y / 2) + (viewport_size.y * 0.2)
	var max_y = camera.global_position.y - (viewport_size.y / 2) + (viewport_size.y * 0.7)
	pipe.position.y = randf_range(min_y, max_y)
	
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
	hidden_points += 1
	if hidden_points == 5:
		point_scored.emit()
		randomize()
		var show_background1 = randf() < 0.5
		var show_background2 = randf() < 0.5
		#var show_background3 = randf() < 0.5
		#var show_background4 = randf() < 0.5
		background_1.visible = show_background1
		background_2.visible = show_background2
		#background_3.visible = show_backround3
		#background_4.visible = show_backround4
		hidden_points = 0
	else:
		point_scored.emit()

func _on_speed_button_pressed() -> void:
	pipe_speed = -300 # if you change the pipe speed, but not the ground speed, this is great when you want to change the scene after a certain point. Its very cool. 
		
	#	add a variable how many pipes spawn at a time. however, you need to setup to make sure that works
