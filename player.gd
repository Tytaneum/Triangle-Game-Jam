extends CharacterBody2D

@export var speed = 400
var screen_size
var gravity = 20
var gigadrill = false

func _ready():
	screen_size = get_viewport_rect().size

func _physics_process(delta: float):
	
	if !is_on_floor():
		velocity.y += gravity
		$AnimatedSprite2D.play("fall")
		move_and_slide()
	else:
		get_input()
		animation_handler()
		move_and_slide()
	
	if Input.is_action_just_pressed("super"):
		print("SMASH!!!!!!!")

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	
func animation_handler():
	if Input.is_action_pressed("right"):
		$AnimatedSprite2D.play("dig_side")
	if Input.is_action_pressed("left"):
		$AnimatedSprite2D.play("dig_side")
		$AnimatedSprite2D.flip_h
	if Input.is_action_pressed("down"):
		$AnimatedSprite2D.play("dig_down")
	else:
		$AnimatedSprite2D.play("idle")
