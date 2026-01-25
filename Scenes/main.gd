extends Node2D

var game_time

func _ready():
	game_time = $ScreenUi/TIME/Timer
	game_time.start(Global.TIME)

func _physics_process(_delta: float):
	if int(game_time.time_left) == 0:
		game_time.stop()
		print("Game Over")
