extends Node2D

var total_score
@export var current_score = 0
var increasing = true
@onready var bar = $TextureProgressBar

func _ready():
	total_score = 10
	current_score = 1
	
func _physics_process(_delta: float):
	
	auto()
	if Input.is_action_just_pressed("super"):
		queue_free()
		return int(current_score)
	#print("Current Score: ", current_score, " Total Score: ", total_score)


func auto():
	if total_score == 0:
		print("game over")
		queue_free()
	elif current_score >= total_score:
		increasing = false
	elif current_score <= 0:
		increasing = true
		total_score -= 1
	
	if increasing:
		increment()
	else:
		decrement() 
	
func increment():
	current_score += .2
	bar.value += 2
	
func decrement():
	current_score -= .2
	bar.value -= 2
