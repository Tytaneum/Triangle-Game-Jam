extends Node2D

func _ready():
	await get_tree().create_timer(.3).timeout
	$TextureProgressBar.max_value = $Timer.wait_time
	Global.TIME = $Timer.wait_time

func _physics_process(_delta: float):
	Global.TIME -= _delta
	$Timer.wait_time = Global.TIME
	$TextureProgressBar.value = Global.TIME
