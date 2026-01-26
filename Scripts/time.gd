extends Node2D

var done

func _ready():
	await get_tree().create_timer(.3).timeout
	$TextureProgressBar.max_value = $Timer.wait_time
	Global.TIME = $Timer.wait_time
	done = false;

func _physics_process(_delta: float):
	if Global.TIME > 0:
		Global.TIME -= _delta
		$Timer.wait_time = Global.TIME
		$TextureProgressBar.value = Global.TIME
	elif $Timer.wait_time != 0:
		$Timer.wait_time = 0
		$TextureProgressBar.value = 0
		if !done:
			finish()

func finish():
	done = true
	$Timer.wait_time = 1
	$Timer.start()
