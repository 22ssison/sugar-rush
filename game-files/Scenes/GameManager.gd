extends Node

@onready var bird: Bird = $"../Bird" as Bird
@onready var pipe_spawner: PipeSpawner = $"../PipeSpawner" as PipeSpawner
@onready var ground: Ground = $"../Ground" as Ground
@onready var ui: CanvasLayer = $"../UI" as UI
@onready var label: Label = $"../Label" as Label
@onready var title: Button = $"../UI/Title"


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
	title.visible = false
	pipe_spawner.start_spawning_pipes()
func end_game():
	ground.stop()
	bird.kill()
	pipe_spawner.stop( )
	ui.on_game_over( )
	
func on_point_scored():
	points += 1
	ui.update_points(points)
	
# implement the random function to spawn random background, birds, etc all together. 
