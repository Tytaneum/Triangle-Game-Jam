extends Node2D

func _ready():
	await get_tree().create_timer(.3).timeout
	$TextureProgressBar.max_value = $Timer.wait_time
	print($Timer.wait_time)

func _physics_process(_delta: float):
	$TextureProgressBar.value = $Timer.time_left
