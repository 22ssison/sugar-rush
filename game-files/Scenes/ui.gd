extends CanvasLayer

class_name UI

@onready var points_label: Label = $MarginContainer/PointsLabel
@onready var game_over_box: VBoxContainer = $MarginContainer/GameOverBox
@onready var high_score_label: Label = $HighScoreLabel

func _ready():
	points_label.text = "%d" % 0
	
func update_points(points: int):
	points_label.text = "%d" % points
	
func update_high_score(high_score: int):
	high_score_label.text = "high score = %d" % high_score

func on_game_over():
	game_over_box.visible = true

func _on_button_pressed(): 
	get_tree().reload_current_scene() #reloads everything including high score label. 
 
