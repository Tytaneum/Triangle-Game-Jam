extends CharacterBody2D

@export var speed = 400
var screen_size
var gravity = 20
var colliderShape

func _ready():
	screen_size = get_viewport_rect().size
	colliderShape = $"Break Radius".get_child(0).shape.size

func _physics_process(_delta):
	zoom_camera(Global.camera_zoom)
	set_color(Global.gigadrill)
	if !is_on_floor(): # ive got my eye on you
		$AnimatedSprite2D.rotation_degrees = 0
		velocity.y += gravity
		if not Input.is_action_pressed("down"):
			$AnimationPlayer.play("fall")
		if Input.is_action_pressed("left"):
			velocity.x += -speed * .01
			$AnimationPlayer.play("dig_side")
			$AnimatedSprite2D.flip_h = true
		if Input.is_action_pressed("right"):
			velocity.x += speed * .01
			$AnimationPlayer.play("dig_side")
			$AnimatedSprite2D.flip_h = false
		move_and_slide()
	elif !Global.cutscene:
		get_input()
		direction_handler()
		move_and_slide()
		
	if Global.gigadrill  and Input.is_action_just_pressed("super") and !Global.cutscene:
		$AnimationPlayer.play("megaton_charge")
		$AnimationPlayer.queue("megaton_spin")
		$"Charging Particles".emitting = true
		$"Charging Particles2".emitting = true
		$Bubbles.emitting = false
		Global.cutscene = true
		add_child.call_deferred(load("res://Scenes/minigames/megaton.tscn").instantiate())
		Global.gigadrill = false
		await child_exiting_tree
		$"Charging Particles".emitting = false
		$"Charging Particles2".emitting = false
		$Bubbles.emitting = true
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
		$"Break Radius".get_child(0).shape.size.x = 6 * colliderShape.x
		$"Break Radius".get_child(0).shape.size.y = 7 * colliderShape.y
		await get_tree().create_timer(.5).timeout
		if value < 166:
			# Slam down animation
			$AnimationPlayer.play("giga_lv1_dive")
			print("SMASH!!!!!!!1")
			
	
	if value > 166:
		$"Break Radius".position.y = -160
		Global.camera_zoom = .9
		Global.gem_meter -= 166
		$AnimationPlayer.play("giga_lv2_grow")
		$AnimationPlayer.queue("giga_lv2_spin")
		$"Break Radius".get_child(0).shape.size.x = 9.5 * colliderShape.x
		$"Break Radius".get_child(0).shape.size.y = 10.5 * colliderShape.y
		await get_tree().create_timer(.5).timeout
		if value < 332:
			# Slam down animation
			$AnimationPlayer.play("giga_lv2_dive")
			print("SMASH!!!!!!!2")
			
			
	if value > 332:
		$"Break Radius".position.y = -200
		Global.camera_zoom = .6
		Global.gem_meter -= 166
		$AnimationPlayer.play("giga_lv3_grow")
		$AnimationPlayer.queue("giga_lv3_spin")
		$"Break Radius".get_child(0).shape.size.x = 13 * colliderShape.x
		$"Break Radius".get_child(0).shape.size.y = 16 * colliderShape.y
		await get_tree().create_timer(.5).timeout
		$AnimationPlayer.play("giga_lv3_dive")
		print("SMASH!!!!!!!3")
			
	$"Break Radius".position.y = 20
	$"Break Radius".get_child(0).shape.size.y = 1 * colliderShape.y
	Global.camera_zoom = 2
	Global.points /= (498 / value)
	while Global.points > 0: 
		position.y += 32
		Global.points -= 1
		await get_tree().create_timer(.3).timeout
	Global.cutscene = false
	$"Break Radius".get_child(0).shape.size.x = 1 * colliderShape.x

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
