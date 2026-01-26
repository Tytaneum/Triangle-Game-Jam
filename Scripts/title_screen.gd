extends Node2D

func _ready() -> void:
	$AnimationPlayer.play("title_fade")
	$AnimationPlayer.queue("title oscilate")
	$"Drill Selector".play()
	$"Start Button".grab_focus()
	$StartTransition.visible = false
	$"controls ui".visible = false

func _physics_process(delta: float) -> void:
	if $"Start Button".has_focus():
		$"Drill Selector".position = Vector2(430,526)
	if $"Controls Button".has_focus():
		$"Drill Selector".position = Vector2(376,603)
	
	if $"controls ui".visible and not $"UI AnimationPlayer".is_playing():
		if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_cancel"):
			$"Controls Button".grab_focus()
			$"UI AnimationPlayer".play("RESET")
			$"controls ui".visible = false
			



func _on_start_button_pressed() -> void:
	$"UI AnimationPlayer".play("start select")
	$"Start Button".release_focus()


func _on_controls_button_pressed() -> void:
	$"Controls Button".release_focus()
	$"UI AnimationPlayer".play("controls select")
	if Input.get_joy_name(0) != "":
		$"controls ui".frame = 1
	else:
		$"controls ui".frame = 0
	$"controls ui".visible =  true
	
	pass #idk do controls menu stuff


func _on_ui_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "start select":
		$StartTransition.visible = true
		$StartTransition/AnimationPlayer.play("closing_transition")
		await  $StartTransition/AnimationPlayer.animation_finished
		get_tree().change_scene_to_file("res://Scenes/intro_scene.tscn")
