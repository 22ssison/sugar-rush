extends Node

@onready var bird: Bird = $"../Bird" as Bird
@onready var pipe_spawner: PipeSpawner = $"../PipeSpawner" as PipeSpawner
@onready var ground: Ground = $"../Ground" as Ground
#@onready var fade: Fade = $"../Fade" as Fade
@onready var ui: CanvasLayer = $"../UI" as UI
@onready var label: Label = $"../Label" as Label
@onready var moon = $"../UI/Moon Button"
@onready var background1 = $"../Background"
@onready var background2 = $"../Backround 2"

var points = 0

func _ready():
	randomize()
	bird.game_started.connect(on_game_started)
	ground.bird_crashed.connect(end_game)
	pipe_spawner.bird_crashed.connect(end_game)
	pipe_spawner.point_scored.connect(on_point_scored)
	   
func on_game_started(): 
	label.visible = false # description of the game at the start.
	pipe_spawner.start_spawning_pipes()
	moon.visible = false #when you start, button disappears. 
func end_game():
	moon.visible = true # when you die, button reappears.
	#fade.play()
	ground.stop()
	bird.kill()
	pipe_spawner.stop( )
	ui.on_game_over( )
	
func on_point_scored():
	randomize()
	var show_backround1 = randf() < 0.5
	var show_backround2 = randf() < 0.5
	points += 1
	ui.update_points(points)
	background1.visible = show_backround1
	background2.visible = show_backround2
