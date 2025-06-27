extends Node

@onready var bird: Bird = $"../Bird" as Bird
@onready var pipe_spawner: PipeSpawner = $"../PipeSpawner" as PipeSpawner
@onready var ground: Ground = $"../Ground" as Ground
@onready var fade: Node = $"../Fade"


@onready var ui: CanvasLayer = $"../UI" as UI
@onready var label: Label = $"../Label" as Label
@onready var moon = $"../UI/Moon Button"

 #to implement different background just create background 3 and 4
# then implement it on randomize()

var points = 0

func _ready():
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
	fade.play()
	ground.stop()
	bird.kill()
	pipe_spawner.stop( )
	ui.on_game_over( )
	
func on_point_scored():
	points += 1
	ui.update_points(points)
