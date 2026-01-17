extends Area2D

func _physics_process(delta: float):
	position = Vector2.ZERO
	if Input.is_action_pressed("right"):
		position.x = 40
		position.y = 0
	elif Input.is_action_pressed("left"):
		position.x = -40
		position.y = 0
	elif Input.is_action_pressed("down"):
		position.x = 0
		position.y = 40
	elif Input.is_action_pressed("up"):
		position.x = 0
		position.y = -40
