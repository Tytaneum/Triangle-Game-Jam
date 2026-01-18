extends Area2D

func interacting():
	$AnimatedSprite2D.play("lined_up")

func not_interacting():
	$AnimatedSprite2D.play("moving")

func _on_area_entered(area: Area2D):
	if area.name == "Target":
		interacting()

func _on_area_exited(area: Area2D):
	if area.name == "Target":
		not_interacting()
