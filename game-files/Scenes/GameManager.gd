extends Node

@onready var bird: Bird = $"../Bird" as Bird
@onready var pipe_spawner: PipeSpawner = $"../PipeSpawner" as PipeSpawner
@onready var ground: Ground = $"../Ground" as Ground
@onready var ui: CanvasLayer = $"../UI" as UI
@onready var label: Label = $"../Label" as Label
@onready var title_banner: Button = $"../UI/Title Banner"
@onready var title: Label = $"../UI/Title"
@onready var loosinghorn: AudioStreamPlayer = $"../loosinghorn"

var points = 0
var total_points = 0
var high_score = 0
var overall_score = 0

func _ready():			
	bird.game_started.connect(on_game_started)
	ground.bird_crashed.connect(end_game)
	pipe_spawner.bird_crashed.connect(end_game)
	pipe_spawner.point_scored.connect(on_point_scored)
	load_high_score()  # Load high score at start

func on_game_started():
	# Hide menu/UI elements
	label.visible = false
	title_banner.visible = false
	title.visible = false

	# Start spawning pipes and difficulty scaling
	pipe_spawner.start_game()

func end_game():
	ground.stop()
	bird.kill()
	pipe_spawner.stop()
	ui.on_game_over()
	loosinghorn.play()
	
func on_point_scored():
	points += 1
	total_points += 1
	overall_score += 1
	ui.update_total_score(overall_score)
	ui.update_high_score(high_score)
	if high_score < total_points:
		high_score = total_points
		save_high_score()
	ui.update_points(points)
	
func save_high_score():
	var config = ConfigFile.new()
	config.set_value("scores", "high_score", high_score)
	config.save("user://save_game.cfg")

func load_high_score():
	var config = ConfigFile.new()
	var err = config.load("user://save_game.cfg")
	if err == OK:
		high_score = config.get_value("scores", "high_score", 0)
	else:
		high_score = 0

func _on_point_button_pressed() -> void:
	on_point_scored()

func _on_reset_point_pressed() -> void:
	high_score = 0
	points = 0
