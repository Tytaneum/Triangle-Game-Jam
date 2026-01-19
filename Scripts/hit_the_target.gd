extends Node2D


@export var current_score = 0
@onready var target1 = $Target1/PathFollow2D
@onready var target2 = $Target2/PathFollow2D

func _ready():
	target1.speed = 2
	target2.speed = 3

func _physics_process(_delta: float):
	hit()


func hit():
	if Input.is_action_just_pressed("super"):
		target1.speed = 0
		target2.speed = 0
		await get_tree().create_timer(.5).timeout
		queue_free()
		score_math()

func score_math():
	var progress1 = 0
	var progress2 = 0
	#
	current_score = 10 - (abs(progress1 - progress2) * 2)
	if current_score < 0:
		current_score = 0
	
	print(current_score)
