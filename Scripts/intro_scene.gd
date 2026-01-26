extends CanvasLayer


func _ready() -> void:
	await get_tree().create_timer(24.73).timeout
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
