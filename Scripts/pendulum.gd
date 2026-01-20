extends Node2D

@export var current_score = 0
@onready var target = $pendulum_target_path/PathFollow2D

func _ready():
	target.speed = 3
	$Target.pendulum_target = true

func _physics_process(_delta: float):
	hit()

func hit():
	if Input.is_action_just_pressed("super"):
		target.speed = 0
		await get_tree().create_timer(.5).timeout
		queue_free()
		score_math()

func score_math():
	var progress = int(target.progress_ratio * 100)
	if progress >= 50:
		progress -= 50
	
	current_score = 10 - (abs(25 - progress))
	if current_score < 0:
		current_score = 0
	
	print(current_score)
