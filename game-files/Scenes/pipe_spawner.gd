extends Node

class_name PipeSpawner

signal bird_crashed
signal point_scored

var pipe_pair_scene = preload("res://Scenes/pipe_pair.tscn")

@onready var spawn_timer: Timer = $SpawnTimer

@onready var bird_node = $"../Bird"
@onready var bird_list = [
	bird_node.get_node("Marshmallowbird"),
	bird_node.get_node("gummybird")
]

@onready var background_list = [
	$"../Background 1",
	$"../Background 2",
	$"../Background 3",
	$"../Background 4"
]

@export var pipe_speed = -500

var current_pipe_skin_index = 0

var hidden_points = 0
var current_theme_index = 0

func _ready():
	spawn_timer.start()
	randomize()

func start_spawning_pipes():
	spawn_timer.timeout.connect(spawn_pipe)

func spawn_pipe():
	var pipe = pipe_pair_scene.instantiate() as PipePair
	add_child(pipe)  # ✅ this triggers _ready() in pipe_pair
	pipe.set_pipe_skin(current_pipe_skin_index)  # ✅ safe now!

	var camera = get_viewport().get_camera_2d()
	if camera == null:
		print("Camera2D not found!")
		return

	var viewport_size = get_viewport().get_visible_rect().size
	pipe.position.x = camera.global_position.x + (viewport_size.x / 2) + 100
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
	for pipe in get_children():
		if pipe is PipePair:
			pipe.speed = 0

func on_point_scored():
	hidden_points += 1
	point_scored.emit()

	if hidden_points % 1 == 0:
		current_theme_index = (current_theme_index + 1) % background_list.size()
		_update_theme(current_theme_index)

func _update_theme(index):
	# Cycle backgrounds
	for i in range(background_list.size()):
		background_list[i].visible = (i == index)

	# Cycle birds
	for i in range(bird_list.size()):
		bird_list[i].visible = (i == index % bird_list.size())

	# Store index to apply to future pipes
	current_pipe_skin_index = index % 2

func _on_speed_button_pressed():
	pipe_speed = -300
