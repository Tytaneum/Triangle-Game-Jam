extends Node2D

var game_time

func _ready():
	game_time = $ScreenUi/TIME/Timer
	game_time.start(Global.TIME)

func _physics_process(_delta: float):
	print(Global.current_depth)
	if int(game_time.time_left) == 0:
		game_time.stop()
		Global.cutscene = true
		print("Game Over")
		
	if Global.current_depth == Global.FINAL_DEPTH:
		game_time.stop()
		Global.cutscene = true
		print("You Win")
