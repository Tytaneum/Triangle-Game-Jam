extends CharacterBody2D

@export var speed = 400
var screen_size
var gravity = 20
var cutscene = false

func _ready():
	screen_size = get_viewport_rect().size

func _physics_process(_delta):
	zoom_camera(Global.camera_zoom)
	
	if !is_on_floor():
		$AnimatedSprite2D.rotation_degrees = 0
		velocity.y += gravity
		if not Input.is_action_pressed("down"):
			$AnimationPlayer.play("fall")
		if Input.is_action_pressed("left"):
			velocity.x += -speed * .01
			$AnimatedSprite2D.flip_h = true
		if Input.is_action_pressed("right"):
			velocity.x += speed * .01
			$AnimatedSprite2D.flip_h = false
		move_and_slide()
	elif !cutscene:
		get_input()
		direction_handler()
		move_and_slide()
		
	if Global.gigadrill  and Input.is_action_just_pressed("super"):
		Global.gigadrill = false
		cutscene = true
		$"Break Radius".set_physics_process(false)
		add_child.call_deferred(load("res://Scenes/minigames/megaton.tscn").instantiate())
		await child_exiting_tree
		gigadrill_math($"Gigadrill Progress".value)

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	
func direction_handler():
	if Input.is_action_pressed("right") and Global.gigadrill == true:
		$AnimatedSprite2D.play("gigadig_side")
		$AnimatedSprite2D.flip_h = false
	
	elif Input.is_action_pressed("left") and Global.gigadrill == true:
		$AnimatedSprite2D.play("gigadig_side")
		$AnimatedSprite2D.flip_h = true
	
	elif Input.is_action_pressed("down") and Global.gigadrill == true:
		$AnimatedSprite2D.play("gigadig_down")
		
	elif Input.is_action_pressed("right"):
		$AnimatedSprite2D.play("dig_side")
		$AnimatedSprite2D.flip_h = false
		
	elif Input.is_action_pressed("left"):
		$AnimatedSprite2D.play("dig_side")
		$AnimatedSprite2D.flip_h = true
	
	elif Input.is_action_pressed("down"):
		$AnimatedSprite2D.rotation_degrees = 0
		$AnimationPlayer.play("dig_down")
	
	else:
		$AnimatedSprite2D.rotation_degrees = 0
		if $AnimationPlayer.current_animation == "fall" and is_on_floor():
			$AnimationPlayer.play("landing")
			$AnimationPlayer.queue("idle")
		elif $AnimationPlayer.current_animation not in ["landing", "giga_lv1_grow", "giga_lv1_spin"]:
			$AnimationPlayer.play("idle")

func zoom_camera(value):
	$Camera2D.zoom = Vector2(value, value)

func gigadrill_math(value): # Will be used to set the drill animation
	$"Break Radius".position.y = -60
	if value > 0:
		Global.camera_zoom = 1.2
		$AnimationPlayer.play("giga_lv1_grow")
		$AnimationPlayer.queue("giga_lv1_spin")
		$"Break Radius".scale.x = 6
		await $AnimationPlayer.current_animation_changed
		$"Gigadrill Progress".value -= 166
		if value < 166:
			# Slam down animation
			print("SMASH!!!!!!!1")
			return
	
	if value > 166:
		Global.camera_zoom = .9
		$AnimationPlayer.play("giga_lv2_grow")
		$AnimationPlayer.queue("giga_lv2_spin")
		$"Break Radius".scale.x = 6
		await $AnimationPlayer.current_animation_changed
		$"Gigadrill Progress".value -= 166
		if value < 332:
			# Slam down animation
			print("SMASH!!!!!!!2")
			return
			
	if value > 332:
		Global.camera_zoom = .6
		$AnimationPlayer.play("giga_lv3_grow")
		$AnimationPlayer.queue("giga_lv3_spin")
		$"Break Radius".scale.x = 6
		await $AnimationPlayer.current_animation_changed
		$"Gigadrill Progress".value -= 166
		if value < 332:
			# Slam down animation
			print("SMASH!!!!!!!3")
			return
			
	await $AnimationPlayer.animation_finished
	cutscene = false
	$"Break Radius".set_physics_process(true)
	Global.camera_zoom = 1
