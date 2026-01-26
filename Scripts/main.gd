extends Node2D

var game_time

func _ready():
	game_time = $ScreenUi/TIME/Timer
	game_time.start(Global.TIME)

func _physics_process(_delta: float):
	if int(game_time.time_left) == 0 and !Global.cutscene:
		game_time.stop()
		Global.cutscene = true
		Global.lose.emit()
		print("Game Over")

	if Global.current_depth == Global.FINAL_DEPTH:
		game_time.stop()
		$Player/AnimationPlayer.stop()
		$Player/SFX.stop()
		Global.cutscene = true
		find_child("EndingTransition").get_child(1).play("win_fade")
		await get_tree().create_timer(4).timeout
		get_tree().change_scene_to_file("res://Scenes/ending.tscn")
		
