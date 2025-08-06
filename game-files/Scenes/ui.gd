extends CanvasLayer

class_name UI

@onready var points_label: Label = $MarginContainer/PointsLabel
@onready var game_over_box: VBoxContainer = $MarginContainer/GameOverBox
@onready var high_score_label: Label = $HighScoreLabel
var game_end = false
func _ready():
	var game_end = false
	points_label.text = "%d" % 0
	
func update_points(points: int):
	points_label.text = "%d" % points
	
func update_high_score(high_score: int):
	high_score_label.text = "high score = %d" % high_score

func on_game_over():
	game_over_box.visible = true
	game_end = true

func _process(delta):
	if game_end and Input.is_action_just_pressed("restart"):
		print("hi")
		get_tree().reload_current_scene()



func _on_reset_button_pressed() -> void:
	get_tree().reload_current_scene() 
