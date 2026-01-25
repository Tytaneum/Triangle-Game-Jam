extends Node2D

func _ready() -> void:
	$AnimationPlayer.play("title_fade")
	$AnimationPlayer.queue("title oscilate")
	$"Drill Selector".play()
	$"Start Button".grab_focus()

func _physics_process(delta: float) -> void:
	if $"Start Button".has_focus():
		$"Drill Selector".position = Vector2(430,526)
	if $"Controls Button".has_focus():
		$"Drill Selector".position = Vector2(376,603)



func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_controls_button_pressed() -> void:
	pass #idk do controls menu stuff
