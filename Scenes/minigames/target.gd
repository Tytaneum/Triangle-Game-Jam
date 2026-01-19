extends Area2D

@export var pendulum = false
@export var pendulum_target = false

func _ready():
	if pendulum_target:
		$AnimatedSprite2D.play("pendulum_target")
	
	if pendulum:
		$AnimatedSprite2D.play("pendulum_moving")
	
func _physics_process(delta: float):
	if Input.is_action_just_pressed("super"):
		if pendulum:
			$AnimatedSprite2D.play("pendulum_hit")
		elif !pendulum_target:
			$AnimatedSprite2D.play("hit")

func interacting():
	if pendulum:
		$AnimatedSprite2D.play("pendulum_aligned")
	else:
		$AnimatedSprite2D.play("aligned")

func not_interacting():
	if pendulum:
		$AnimatedSprite2D.play("pendulum_moving")
	else:
		$AnimatedSprite2D.play("moving")

func _on_area_entered(area: Area2D):
	if area.name == "Target" and !pendulum_target:
		interacting()

func _on_area_exited(area: Area2D):
	if area.name == "Target" and !pendulum_target:
		not_interacting()
