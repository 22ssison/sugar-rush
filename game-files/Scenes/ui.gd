extends CanvasLayer

class_name UI

@onready var points_label: Label = $MarginContainer/PointsLabel
@onready var game_over_box: VBoxContainer = $MarginContainer/GameOverBox
@onready var high_score_label: Label = $HighScoreLabel
@onready var total_score_label: Label = $TotalPointsLabel
@onready var ui: UI = $"."
@onready var gameplaydescriptions: Button = $gameplaydescriptions
@onready var label: Label = $"../Control/Label"
@onready var exit = $"../Control/Label/exit"
@onready var title: Label = $Title
@onready var title_banner: Button = $"Title Banner"
@onready var margin_container: MarginContainer = $MarginContainer

var game_end = false
func _ready():
	var game_end = false
	points_label.text = "%d" % 0
	label.visible = false
	exit.visible = false
	print("debug test")
	
func update_points(points: int):
	points_label.text = "%d" % points
	
func update_high_score(high_score: int):
	high_score_label.text = "high score = %d" % high_score

func update_total_score(total_score: int):
	total_score_label.text = "Overal score = %d" % total_score
	
func on_game_over():
	game_over_box.visible = true
	game_end = true

func _process(delta):
	if game_end and Input.is_action_just_pressed("restart"):
		print("hi")
		get_tree().reload_current_scene()

func _on_reset_button_pressed() -> void:
	get_tree().reload_current_scene() 

func _on_gameplaydescriptions_pressed() -> void:
	label.visible = true
	exit.visible = true
	print("label clicked")
	title.visible = false
	title_banner.visible = false
	margin_container.visible = false

func _on_exit_pressed() -> void:
	exit.visible = false
	label.visible = false
	title.visible = true
	title_banner.visible = true
	margin_container.visible = true
