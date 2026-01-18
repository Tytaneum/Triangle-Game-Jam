extends CharacterBody2D

@export var speed = 400
var screen_size
var gravity = 20
var gigadrill = false

func _ready():
	screen_size = get_viewport_rect().size

func _physics_process(delta):
	
	if !is_on_floor():
		velocity.y += gravity
		$AnimationPlayer.play("fall")
		if Input.is_action_pressed("left"):
			velocity.x += -speed * .01
			$AnimatedSprite2D.flip_h = true
			
		if Input.is_action_pressed("right"):
			velocity.x += speed * .01
			$AnimatedSprite2D.flip_h = false
		move_and_slide()
	else:
		get_input()
		direction_handler()
		move_and_slide()
	
	if Input.is_action_just_pressed("super"):
		print("SMASH!!!!!!!")

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	
func direction_handler():
	if Input.is_action_pressed("right") and gigadrill == true:
		$AnimatedSprite2D.play("gigadig_side")
		$AnimatedSprite2D.flip_h = false
	
	elif Input.is_action_pressed("left") and gigadrill == true:
		$AnimatedSprite2D.play("gigadig_side")
		$AnimatedSprite2D.flip_h = true
	
	elif Input.is_action_pressed("down") and gigadrill == true:
		$AnimatedSprite2D.play("gigadig_down")
		
	elif Input.is_action_pressed("right"):
		$AnimatedSprite2D.play("dig_side")
		$AnimatedSprite2D.flip_h = false
		
	elif Input.is_action_pressed("left"):
		$AnimatedSprite2D.play("dig_side")
		$AnimatedSprite2D.flip_h = true
	
	elif Input.is_action_pressed("down"):
		$AnimatedSprite2D.play("dig_down")
	
	else:
		if $AnimationPlayer.current_animation == "fall" and is_on_floor():
			$AnimationPlayer.play("landing")
			$AnimationPlayer.queue("idle")
		elif $AnimationPlayer.current_animation != "landing":
			$AnimationPlayer.play("idle")
