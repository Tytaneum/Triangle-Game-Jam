extends Node2D

func _physics_process(_delta: float):
	$TextureProgressBar.value = $Timer.time_left
