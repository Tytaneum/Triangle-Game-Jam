extends Node2D

var minigames = ["up_and_down.tscn", "hit_the_target.tscn", "pendulum.tscn"]

func _ready():
	if global_position.x < 0:
		position.x += -1
	for i in minigames:
		Global.camera_zoom += .5
		minigame_load(i)
		await child_exiting_tree
		Global.points += int(get_child(0).current_score)
	print(Global.points)
	queue_free()

func minigame_load(minigame):
	add_child.call_deferred(load("res://Scenes/minigames/" + minigame).instantiate())
