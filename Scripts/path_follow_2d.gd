extends PathFollow2D

@export var speed = 1

func _physics_process(delta: float):
	progress += speed
