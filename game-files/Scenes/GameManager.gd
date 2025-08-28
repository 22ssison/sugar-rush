extends Node
@onready var bird: Bird = $"../Bird"
@onready var control: Control = $"../Control"

@onready var pipe_spawner: PipeSpawner = $"../PipeSpawner"

@onready var ground: Ground = $"../Ground"
@onready var ui: UI = $"../UI"
@onready var press_space_to_fly: Label = $"../press space to fly"
@onready var title_banner: Button = $"../UI/Title Banner"
@onready var title: Label = $"../UI/Title"
@onready var loosinghorn: AudioStreamPlayer = $"../loosinghorn"
@onready var moon: Label = $"../UI/moon"
@onready var moon_button: Button = $"../UI/Moon Button"
@onready var speed_button: Button = $"../UI/Speed Button"
@onready var gameplaydescriptions: Button = $"../UI/gameplaydescriptions"
@onready var label: Label = $"../Control/Label"
@onready var exit: Button = $"../Control/Label/exit"
@onready var instructions: Label = $"../instructions"


var points = 0
var total_points = 0
var high_score = 0
var overall_score = 0

func _ready():			
	bird.game_started.connect(on_game_started)
	ground.bird_crashed.connect(end_game)
	pipe_spawner.bird_crashed.connect(end_game)
	pipe_spawner.point_scored.connect(on_point_scored)
	load_high_score()

func on_game_started():
	# Hide menu/UI elements
	press_space_to_fly.visible = false
	instructions.visible = false
	title_banner.visible = false
	title.visible = false
	# Start spawning pipes
	pipe_spawner.start_game()
	moon.visible = false
	moon_button.visible = false
	speed_button.visible = false
	gameplaydescriptions.visible = false
	label.visible = false
	exit.visible = false
	

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
