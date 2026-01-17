extends CharacterBody2D

@export var speed = 400
var screen_size
var gravity = 200

func _ready():
	screen_size = get_viewport_rect().size

func _physics_process(delta: float):
	get_input()
	move_and_slide()
	print(!is_on_floor())
	
	if !is_on_floor():
		velocity.y += gravity
		print(velocity.y)
	else:
		velocity.y = 0
		
	
	if Input.is_action_just_pressed("super"):
		print("SMASH!!!!!!!")

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
