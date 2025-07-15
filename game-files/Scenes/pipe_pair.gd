extends Node2D

class_name PipePair

signal bird_entered
signal point_scored

# Top Pipe Variants
@onready var top_candy_pipe = get_node("TopPipe/candycanepipe")
@onready var top_marsh_pipe = get_node("TopPipe/marshmallowpipe")
@onready var top_lol_pipe = get_node("TopPipe/lollipoppipe")
@onready var top_waf_pipe = get_node("TopPipe/waferpipe")

# Bottom Pipe Variants
@onready var bottom_candy_pipe = get_node("BottomPipe/candycanepipe")
@onready var bottom_marsh_pipe = get_node("BottomPipe/marshmallowpipe")
@onready var bottom_lol_pipe = get_node("BottomPipe/lollipoppipe")
@onready var bottom_waf_pipe = get_node("BottomPipe/waferpipe")

var speed = 0

func _ready():
	print("Top candy pipe:", top_candy_pipe)
	print("Bottom candy pipe:", bottom_candy_pipe)

func set_pipe_skin(index):
	var use_candy = index == 0
	var use_marsh = index == 2
	var use_lol = index == 1
	var use_waf = index == 3

	# Top pipes
	top_candy_pipe.visible = use_candy
	top_marsh_pipe.visible = use_marsh
	top_lol_pipe.visible = use_lol
	top_waf_pipe.visible = use_waf

	# Bottom pipes
	bottom_candy_pipe.visible = use_candy
	bottom_marsh_pipe.visible = use_marsh
	bottom_lol_pipe.visible = use_lol
	bottom_waf_pipe.visible = use_waf

func set_speed(new_speed):
	speed = new_speed

func _process(delta):
	position.x += speed * delta

func _on_body_entered(body):
	bird_entered.emit()

func on_point_scored(body):
	speed += 35
	point_scored.emit()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
