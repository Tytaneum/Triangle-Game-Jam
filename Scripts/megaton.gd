extends Node2D

var minigames = ["up_and_down.tscn", "hit_the_target.tscn", "pendulum.tscn"]
var score = 0

func _ready():
	for i in minigames:
		Global.camera_zoom += .5
		minigame_load(i)
		await child_exiting_tree
		score += int(get_child(0).current_score)
	queue_free()

func minigame_load(minigame):
	add_child.call_deferred(load("res://Scenes/minigames/" + minigame).instantiate())
