extends Node
class_name PipeSpawner

signal bird_crashed
signal point_scored

var pipe_pair_scene = preload("res://Scenes/pipe_pair.tscn")

@onready var spawn_timer: Timer = $SpawnTimer
var difficulty_timer: Timer = null

@onready var bird_node = $"../Bird"
@onready var bird_list = [
	bird_node.get_node("Marshmallowbird"),
	bird_node.get_node("gummybird"),
	bird_node.get_node("candywrapbird"),
	bird_node.get_node("chocobird"),
]

@onready var background_list = [
	$"../Background 1",
	$"../Background 2",
	$"../Background 3",
	$"../Background 4"
]

@export var pipe_speed: float = -500
@onready var pointsound: AudioStreamPlayer = $pointsound

var current_pipe_skin_index := 0
var hidden_points := 0
var current_theme_index := 0
var game_started := false

# --- Difficulty & spawn settings ---
@export var base_gap: float = 1500.0         # starting distance between pipes
@export var min_wait_time: float = 0.9       # absolute minimum spawn interval
@export var max_difficulty_points: int = 25  # cap for point-based difficulty
@export var point_scale_factor: float = 0.02 # decrease per point
@export var time_scale_factor: float = 0.01  # decrease per second

func _ready():
	update_spawn_rate()
	ensure_spawn_connection()
	ensure_difficulty_timer()
	randomize()
	stop()  # ensure no pipes spawn at hover screen

# --- START / STOP ---
func start_game():
	if game_started:
		return
	game_started = true
	hidden_points = 0
	current_theme_index = 0
	update_spawn_rate()
	spawn_timer.start()
	difficulty_timer.start()

func stop():
	if spawn_timer:
		spawn_timer.stop()
	if difficulty_timer:
		difficulty_timer.stop()
	for pipe in get_children():
		if pipe is PipePair:
			pipe.speed = 0

# --- TIMERS ---
func ensure_spawn_connection():
	if not spawn_timer.timeout.is_connected(spawn_pipe):
		spawn_timer.timeout.connect(spawn_pipe)

func ensure_difficulty_timer():
	difficulty_timer = get_node_or_null("DifficultyTimer")
	if difficulty_timer == null:
		difficulty_timer = Timer.new()
		difficulty_timer.name = "DifficultyTimer"
		difficulty_timer.wait_time = 1.0
		difficulty_timer.one_shot = false
		add_child(difficulty_timer)
	if not difficulty_timer.timeout.is_connected(_on_difficulty_timer_timeout):
		difficulty_timer.timeout.connect(_on_difficulty_timer_timeout)

# --- PIPE SPAWN ---
func spawn_pipe():
	if not game_started:
		return
	var pipe = pipe_pair_scene.instantiate() as PipePair
	add_child(pipe)
	pipe.set_pipe_skin(current_pipe_skin_index)

	var camera = get_viewport().get_camera_2d()
	if camera == null:
		print("Camera2D not found!")
		return

	var viewport_size = get_viewport().get_visible_rect().size
	pipe.position.x = camera.global_position.x + (viewport_size.x / 2) + 100

	var min_y = camera.global_position.y - (viewport_size.y / 2) + (viewport_size.y * 0.2)
	var max_y = camera.global_position.y - (viewport_size.y / 2) + (viewport_size.y * 0.7)

	# Reduce gap gradually but cap it
	if hidden_points > 0:
		var gap_ratio = min(hidden_points, max_difficulty_points) / max_difficulty_points
		var gap_reduction: float = gap_ratio * 0.15 * (max_y - min_y)
		min_y += gap_reduction * 0.5
		max_y -= gap_reduction * 0.5

	pipe.position.y = randf_range(min_y, max_y)

	pipe.bird_entered.connect(on_bird_entered)
	pipe.point_scored.connect(on_point_scored)
	pipe.set_speed(pipe_speed)

# --- EVENTS ---
func on_bird_entered():
	bird_crashed.emit()
	stop()

func on_point_scored():
	hidden_points += 1
	point_scored.emit()
	pointsound.play()

	# Exponential point-based scaling
	if hidden_points <= max_difficulty_points:
		spawn_timer.wait_time *= (1.0 - point_scale_factor)
		spawn_timer.wait_time = max(spawn_timer.wait_time, min_wait_time)

	# Cycle themes
	current_theme_index = (current_theme_index + 1) % background_list.size()
	_update_theme(current_theme_index)

# --- THEME SWITCH ---
func _update_theme(index):
	for i in range(background_list.size()):
		background_list[i].visible = (i == index)
	for i in range(bird_list.size()):
		if bird_list[i] != null:
			bird_list[i].visible = (i == index % bird_list.size())
	current_pipe_skin_index = index % 4

# --- SPEED MODE ---
func _on_speed_button_pressed():
	pipe_speed = -1000
	update_spawn_rate()

# --- UPDATE SPAWN RATE ---
func update_spawn_rate():
	var denom: float = max(absf(pipe_speed), 1.0)
	var wait_time: float = base_gap / denom
	spawn_timer.wait_time = max(wait_time, min_wait_time)

func _on_difficulty_timer_timeout():
	if hidden_points <= max_difficulty_points:
		spawn_timer.wait_time *= (1.0 - time_scale_factor)
		spawn_timer.wait_time = max(spawn_timer.wait_time, min_wait_time)
