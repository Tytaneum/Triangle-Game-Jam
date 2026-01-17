extends Area2D

func _physics_process(delta: float):
	position.y = 40
	position.x = 0
	if Input.is_action_pressed("right"):
		position.x = 40
		position.y = 0
	elif Input.is_action_pressed("left"):
		position.x = -40
		position.y = 0
	elif Input.is_action_pressed("up"):
		position.x = 0
		position.y = -40
