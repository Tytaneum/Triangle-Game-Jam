extends Node2D

var total_score
var current_score
var increasing = true

func _ready():
	total_score = 10
	current_score = 1
	
func _physics_process(delta: float):
	auto()
	if Input.is_action_just_pressed("super"):
		print(current_score)
		queue_free()
		return current_score
	print("Current Score: ", current_score, " Total Score: ", total_score)
	
func auto():
	if total_score == 0:
		print("game over")
		queue_free()
	elif current_score == total_score:
		increasing = false
	elif current_score == 0:
		increasing = true
		total_score -= 1
	
	if increasing:
		increment()
	else:
		decrement() 
	
func increment():
	current_score += 1
	
func decrement():
	current_score -= 1
