extends CharacterBody2D

@export var speed = 400
var screen_size
var gravity = 20

func _ready():
	screen_size = get_viewport_rect().size
		#set_color(false)

func _physics_process(_delta):
	zoom_camera(Global.camera_zoom)
	set_color(Global.gigadrill)
	
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
	elif !Global.cutscene:
		get_input()
		direction_handler()
		move_and_slide()
		
	if Global.gigadrill  and Input.is_action_just_pressed("super") and !Global.cutscene:
		$AnimationPlayer.play("idle")
		Global.cutscene = true
		add_child.call_deferred(load("res://Scenes/minigames/megaton.tscn").instantiate())
		Global.gigadrill = false
		await child_exiting_tree
		gigadrill_math(Global.gem_meter)

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	
func direction_handler():
	if Input.is_action_pressed("right"):
		$AnimationPlayer.play("dig_side")
		$AnimatedSprite2D.flip_h = false
		
	elif Input.is_action_pressed("left"):
		$AnimationPlayer.play("dig_side")
		$AnimatedSprite2D.flip_h = true
	
	elif Input.is_action_pressed("down"):
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
	$"Break Radius".position = Vector2(0, 0)
	if value > 0:
		$"Break Radius".position.y = -125
		Global.camera_zoom = 1.2
		Global.gem_meter -= 166
		$AnimationPlayer.play("giga_lv1_grow")
		$AnimationPlayer.queue("giga_lv1_spin")
		$"Break Radius".scale.x = 6
		$"Break Radius".scale.y = 7
		await get_tree().create_timer(.5).timeout
		if value < 166:
			# Slam down animation
			print("SMASH!!!!!!!1")
			
	
	if value > 166:
		$"Break Radius".position.y = -160
		Global.camera_zoom = .9
		Global.gem_meter -= 166
		$AnimationPlayer.play("giga_lv2_grow")
		$AnimationPlayer.queue("giga_lv2_spin")
		$"Break Radius".scale.x = 9.5
		$"Break Radius".scale.y = 10.5
		await get_tree().create_timer(.5).timeout
		if value < 332:
			# Slam down animation
			print("SMASH!!!!!!!2")
			
			
	if value > 332:
		$"Break Radius".position.y = -200
		Global.camera_zoom = .6
		Global.gem_meter -= 166
		$AnimationPlayer.play("giga_lv3_grow")
		$AnimationPlayer.queue("giga_lv3_spin")
		$"Break Radius".scale.x = 13
		$"Break Radius".scale.y = 16
		await get_tree().create_timer(.5).timeout
		print("SMASH!!!!!!!3")
			
	$"Break Radius".position.y = 40
	$"Break Radius".scale.y = 1
	Global.camera_zoom = 2
	Global.points /= 1.5
	while Global.points > 0: 
		position.y += 32
		Global.points -= 1
		await get_tree().create_timer(.3).timeout
	#await $AnimationPlayer.animation_finished
	await get_tree().create_timer(.5).timeout
	Global.cutscene = false
	$"Break Radius".scale.x = 1

func set_color(giga_mode): #recolors the player
	if giga_mode: #hyper giga whatever mode color (SET TO FALSE DURING THE ACTUAL GIGA DRILL PART)
		$AnimationPlayer.speed_scale = 3
		$AnimatedSprite2D.material.set("shader_parameter/ALT_BODY", Color(1.0, 0.725, 0.078))
		$AnimatedSprite2D.material.set("shader_parameter/ALT_ACCENT", Color(0.9, 0.063, 0.258))
		$AnimatedSprite2D.material.set("shader_parameter/ALT_DRILL", Color(0.882, 0.977, 0.98))
		$AnimatedSprite2D.material.set("shader_parameter/ALT_DRILL_2", Color(0.621, 0.73, 0.73))
	else: #default color
		$AnimationPlayer.speed_scale = 1
		$AnimatedSprite2D.material.set("shader_parameter/ALT_BODY", Color(0.51, 0.114, 0.204))
		$AnimatedSprite2D.material.set("shader_parameter/ALT_ACCENT", Color(1.0, 0.725, 0.078))
		$AnimatedSprite2D.material.set("shader_parameter/ALT_DRILL", Color(0.608, 0.714, 0.718))
		$AnimatedSprite2D.material.set("shader_parameter/ALT_DRILL_2", Color(0.467, 0.549, 0.549))
